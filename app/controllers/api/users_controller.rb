class Api::UsersController < Api::ApplicationController
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
    render( { json: @user }.merge set_render_options )
  end

  # GET /users/search_email
  def search_email
    head User.find_by(email: params[:query]).present? ? :ok : :not_found
  end
end
