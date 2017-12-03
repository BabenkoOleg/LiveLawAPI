class Api::ConversationsController < ApplicationController
  before_action :authenticate_api_user!

  def index
    dialogs = Conversation::Dialog.json_for_index(current_api_user)
    render json: dialogs
  end

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
end
