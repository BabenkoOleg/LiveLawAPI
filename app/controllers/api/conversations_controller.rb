class Api::ConversationsController < ApplicationController
  before_action :authenticate_api_user!

  # GET /conversations
  def index
    conversations = Conversation::Dialog.json_for_index(current_api_user)
    render json: conversations
  end

  # GET /conversations/1
  def show
    user = User.find(params[:id])
    dialog = Conversation::Dialog.common(current_api_user, user)
    messages = dialog.messages
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
end
