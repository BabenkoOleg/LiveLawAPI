class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat_token = params[:chat_token]
    chat = Chat.find_by(token: chat_token)

    if chat.present?
      stream_from "chat_#{chat_token}_channel"

      if current_user.specialist? && chat.answerer.nil? && !chat.fresh?
        ActionCable.server.broadcast("chat_#{chat_token}_channel", { type: 'timeout' })
        reject
      elsif current_user.specialist? && chat.answerer.nil? && chat.fresh?
        chat.update(answerer: current_user)
        chat.chatting!
        current_user.chatting!
        ActionCable.server.broadcast("chat_#{chat_token}_channel", { type: 'lawyer_subscribe' })
      elsif current_user.specialist?
        ActionCable.server.broadcast("chat_#{chat_token}_channel", { type: 'lawyer_subscribe' })
      elsif !current_user.specialist?
        ActionCable.server.broadcast("chat_#{chat_token}_channel", { type: 'client_subscribe' })
      end
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
