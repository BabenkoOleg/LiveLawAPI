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
      user = ActiveModelSerializers::SerializableResource.new(@users, {})
                                                         .as_json[:users]

      render json: { chat_token: @chat.token, users: user }, status: :created
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def show
    @chat = Chat.find_by(token: params[:id])

    if current_authorized_user.nil?
      head :forbidden
    elsif @chat.present?
      if [@chat.asker_id, @chat.answerer_id].include? current_authorized_user.id
        specialist =
          ActiveModelSerializers::SerializableResource.new(@chat.answerer, {})
        specialist =
          specialist.as_json[:user].slice(:id, :full_name, :role, :avatar_url)
        chat = ActiveModelSerializers::SerializableResource.new(@chat, {})

        render json: {
          chat: chat.as_json[:chat].merge!({specialist: specialist })
        }, status: :ok
      else
        error = 'Sorry, this is not your chat'
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
