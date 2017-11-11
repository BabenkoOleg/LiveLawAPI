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
        render json: {
          chat: ActiveModelSerializers::SerializableResource.new(chat, { chat_token: true }).as_json[:chat].merge!({
            client: get_client_data(chat),
            lawyer: get_lawyer_data(chat)
          })
        }, status: :ok
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
    if chat.answerer.present?
      chat.answerer.free!
      chat.send_message({
        type: 'reject',
        sender_id: current_authorized_user.id,
        sender_role: current_authorized_user.role
      })
      chat.update(answerer: nil)
    end
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

  def get_client_data(chat)
    { id: chat.asker.id, name: chat.name, avatar: nil }
  end

  def get_lawyer_data(chat)
    return nil if chat.answerer.nil?
    {
      id: chat.answerer.id,
      name: chat.answerer.full_name,
      avatar: chat.answerer.avatar_url
    }
  end
end
