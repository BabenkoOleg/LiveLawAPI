class Api::ChatsController < ApplicationController

  # POST /chats
  def create
    @chat = Chat.new(chat_params)
    #@chat.status = :waiting_specialist
    @chat.status = :conversation
    @chat.asker = current_authorized_user
    @chat.token = SecureRandom.urlsafe_base64(nil, false)

    @users = User.where.not(role: 'client').where(online: true).limit(5)

    if @chat.save
      render json: {
        chat_token: @chat.token,
        users: ActiveModelSerializers::SerializableResource.new(@users, {}).as_json[:users]
      }, status: :created
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:question, :city_id, :category_id)
  end
end
