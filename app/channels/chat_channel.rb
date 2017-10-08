class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat_token = params[:chat_token]
    chat = Chat.find_by(token: chat_token)

    if chat.present?
      if current_user.kind_of?(User) && ['lawyer', 'jurist'].include?(current_user.role) && chat.answerer.nil?
        chat.update(answerer: current_user)
      end

      stream_from "chat_#{chat_token}_channel"
    else
      reject
    end
  end

  def receive(data)
    chat_token = params[:chat_token]
    ActionCable.server.broadcast("chat_#{chat_token}_channel", data)
  end

  def unsubscribed
    if current_user.kind_of? User
      message = { user_id: current_user.id, online: :off }
      ActionCable.server.broadcast('appearance_channel', message)
      current_user.update(online: false)
    end
  end
end
