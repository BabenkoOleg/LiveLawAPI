class Api::UsersController < ApplicationController
  # GET /users
  def index
    @users = User.filter_by(params)

    if params[:page].present?
      pagination = { total_count: @users.total_count, current_page: @users.current_page }
      collection = ActiveModelSerializers::SerializableResource.new(@users, {}).as_json

      render json: { result: collection, pagination: pagination }
    else
      render json: @users
    end
  end

  # GET /users/1
  def show
    render json: @user
  end

  # GET /users/search_email
  def search_email
    head User.find_by(email: params[:query]).present? ? :ok : :not_found
  end

  # POST /users/1/invite_to_chat
  def invite_to_chat
    user = User.find(params[:user_id])
    chat_token = params[:chat_token]

    if (user.lawyer? || user.jurist?) && user.online?
      message = { user_id: user.id, type: :invite, chat_token: chat_token }
      ActionCable.server.broadcast('appearance_channel', message)
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
