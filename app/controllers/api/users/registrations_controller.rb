class Api::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  # POST /resource
  def create
    super
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up)
                              .push(*[:role, :first_name, :last_name, :phone])
  end
end
