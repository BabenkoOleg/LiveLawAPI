class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat_token = params[:chat_token]
    chat = Chat.find_by(token: chat_token)

    if chat.present?
      stream_from "chat_#{chat_token}_channel"
      type = current_user.specialist? ? 'lawyer_subscribe' : 'client_subscribe'
      [chat, current_user].map(&:chatting!) if current_user.specialist?
      ActionCable.server.broadcast("chat_#{chat_token}_channel", { type: type })
    else
      reject
    end
  end

  def receive(message)
    message[:sender_id] = current_user.id
    message[:sender_role] = sender_role
    chat_token = params[:chat_token]
    ActionCable.server.broadcast("chat_#{chat_token}_channel", message)
  end

  def unsubscribed
    chat_token = params[:chat_token]
    ActionCable.server.broadcast("chat_#{chat_token}_channel", {
      type: 'unsubscribe',
      sender_id: current_user.id,
      sender_role: sender_role
    })
  end

  private

  def sender_role
    current_user.kind_of?(User) ? current_user.role : 'client'
  end
end
