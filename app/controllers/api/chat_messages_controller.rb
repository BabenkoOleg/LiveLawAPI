class Api::ChatMessagesController < ApplicationController

  # POST /chat_messages
  def create
    chat = Chat.find_by(token: params[:chat_token])

    if chat.present? && chat.status == 'conversation'
      @message = ChatMessage.new(message_params)
      @message.chat = chat
      @message.sender = current_authorized_user

      if @message.save
        message = { text: @message.text }

        if current_authorized_user.kind_of?(User)
          message[:sender_id] = @message.sender.id

        elsif current_authorized_user.kind_of?(Guest)
          message[:sender_token] = @message.sender.token
        end

        ActionCable.server.broadcast("chat_#{chat.token}_channel", message)
        head :ok

      else
        render json: @message.errors, status: :unprocessable_entity
      end

    elsif chat.present? && chat.status == 'paying'
      render json: { error: 'The chat is not paid yet' }, status: :unprocessable_entity

    elsif chat.present? && chat.status == ' completed'
      render json: { error: 'Chat already completed' }, status: :unprocessable_entity

    else
      render json: { error: 'Chat is not found' }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.permit(:text)
  end
end
