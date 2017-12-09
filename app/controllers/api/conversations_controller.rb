class Api::ConversationsController < ApplicationController
  before_action :authenticate_api_user!

  # GET /conversations
  def index
    conversations =
      Conversation::Dialog.json_for_index(current_api_user, params[:page] || 1)
    render json: conversations
  end

  # GET /conversations/1
  def show
    user = User.find(params[:id])
    dialog = Conversation::Dialog.common(current_api_user, user)
    messages = dialog.messages.order(created_at: :desc)
    render json: {
      page: (params[:page] || 1).to_i,
      total: messages.count,
      user: {
        id: user.id,
        name: user.full_name,
        avatar_url: user.avatar_url
      },
      messages: messages.page(params[:page] || 1).per(50).as_json(only: [
        :sender_id, :text, :read, :created_at
      ])
    }
  end

  # POST /conversations/1
  def create
    user = User.find(params[:id])
    dialog = Conversation::Dialog.common(current_api_user, user)
    message = dialog.messages.new(
      sender: current_api_user,
      recipient: user,
      text: params[:text]
    )
    if message.save
      broadcast_new_message(message)
      render json: message.as_json(only: [
        :sender_id, :text, :read, :created_at
      ])
    else
      render json: message.errors, status: :unprocessable_entity
    end
  end

  # POST /conversations/1/read
  def read
    user = User.find(params[:id])
    dialog = Conversation::Dialog.common(current_api_user, user)
    dialog.messages.where(recipient: current_api_user).update(read: true)
    head :ok
  end

  private

  def broadcast_new_message(message)
    is_chat_open = ActionCable.server.connections.select do |connection|
      connection.current_user.id == message.recipient.id
    end.map do |connection|
      connection.subscriptions.identifiers.map do |identifier|
        JSON.parse(identifier)
      end
    end.flatten.select do |subscription|
      subscription['channel'] == 'ConversationChannel' &&
      subscription['id'] == message.sender.id
    end.any?

    if is_chat_open
      id = [message.sender.id, message.recipient.id].sort.join('#')
      ActionCable.server.broadcast("conversations_#{id}_channel", {
        type: 'message',
        text: message.text,
        sender_id: message.sender.id,
        created_at: message.created_at
      })
    else
      ActionCable.server.broadcast('appearance_channel', {
        type: 'message',
        user_id: message.recipient.id,
        sender_id: message.sender.id,
        message_id: message.id
      })
    end
  end
end
