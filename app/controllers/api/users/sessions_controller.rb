class Api::Users::SessionsController < DeviseTokenAuth::SessionsController

  protected

  def render_create_success
    render json: @resource, include: [:roles], show_roles: true
  end
end
