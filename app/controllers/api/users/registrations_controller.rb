class Api::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

  protected

  def sign_up_params
    params.permit(:email, :password, :role, :first_name, :last_name, :phone)
  end
end
