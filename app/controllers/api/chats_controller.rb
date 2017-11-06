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
      user = ActiveModelSerializers::SerializableResource.new(@users, {}).as_json[:users]
      render json: { chat_token: @chat.token, users: user }, status: :created
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def active
    if current_authorized_user.present?
      chat = current_authorized_user.active_chat
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

  def reject
    chat = current_authorized_user.active_chat
    return head :no_content if chat.nil?
    chat.answerer.free! if chat.answerer.present?
    if chat.invited?
      chat.bought!
    elsif chat.chatting?
      chat.completed!
    end
    head :ok
  end

  private

  def chat_params
    params.require(:chat).permit(:question, :name, :city_id, :category_id)
  end

  def get_interlocutor(chat)
    if current_authorized_user.specialist?
      interlocutor = {
        id: chat.asker.id,
        name: chat.name,
        avatar: nil
      }
    elsif chat.answerer.present?
      interlocutor = {
        id: chat.answerer.id,
        name: chat.answerer.full_name,
        avatar: chat.asker.avatar_url
      }
    end
  end
end
