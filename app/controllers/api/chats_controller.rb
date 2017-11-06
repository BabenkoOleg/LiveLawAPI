class Api::ChatsController < ApplicationController

  # POST /chats
  def create
    @chat = Chat.new(chat_params)
    #@chat.status = :created
    @chat.status = :bought # ToDo: remove eto na her
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

  def active
    if current_authorized_user.present?
      chat = current_authorized_user.current_chat
      if chat.present?
        user = get_interlocutor(chat)
        chat = ActiveModelSerializers::SerializableResource.new(chat, { chat_token: true })
        render json: { chat: chat.as_json[:chat].merge!({ user: user }) }, status: :ok
      else
        head :no_content
      end
    else
      head :forbidden
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:question, :name, :city_id, :category_id)
  end

  def get_interlocutor(chat)
    if current_authorized_user.kind_of?(User) && (current_authorized_user.lawyer? || current_authorized_user.jurist?)
      interlocutor = {
        id: chat.asker.id,
        name: chat.name
      }
    else
      if chat.answerer.present?
        interlocutor = {
          id: chat.answerer.id,
          name: chat.answerer.full_name
        }
      end
    end
  end
end
