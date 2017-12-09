class Api::UsersController < ApplicationController
  # GET /users
  def index
    @users = User.filter_by(params)
    render json: {
      page: @users.current_page,
      total: @users.total_count,
      users: @users
    }
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    render json: @user
  end

  # POST /users/1/upload_avatar
  def upload_avatar
    @user = User.find(params[:user_id])
    @user.update(avatar: params[:avatar])
    render json: { avatar_url: @user.avatar.url }
  end

  # GET /users/search_email
  def search_email
    render json: { success: User.find_by(email: params[:query]).present? }
  end

  # POST /users/1/invite_to_chat
  def invite_to_chat
    user = User.find(params[:user_id])
    chat = Chat.find_by(token: params[:chat_token])

    if chat.created?
      head :payment_required
    elsif (user.lawyer? || user.jurist?) && user.online?
      chat.update(answerer: user, invited_at: DateTime.now.utc, status: 'invited')
      user.invited!
      ActionCable.server.broadcast('appearance_channel', {
        type: 'invite',
        user_id: user.id,
        chat_token: chat.token,
        text: chat.question
      })
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
