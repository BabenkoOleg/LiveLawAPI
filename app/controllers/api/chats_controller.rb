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

  def show
    @chat = Chat.find_by(token: params[:id])

    if current_authorized_user.nil?
      head :forbidden
    elsif @chat.present?
      if [@chat.asker, @chat.answerer].include? current_authorized_user
        render json: @chat
      else
        error = 'Kiss my shiny metal ass, this is not your chat'
        render json: { error: error }, status: :forbidden
      end
    else
      head :not_found
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:question, :city_id, :category_id)
  end
end
