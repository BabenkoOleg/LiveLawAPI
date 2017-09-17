class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  def register_user(params)
    user = User.find_by(email: user_params[:email])

    return user if user.present?

    password = User.random_password
    user = User.create(
      email:                 user_params[:email],
      first_name:            user_params[:first_name],
      password:              password,
      password_confirmation: password,
      confirmed_at:          DateTime.now,
      role:                  :client
    )

    user.cities << City.find_by(id: user_params[:city_id])

    client_id = SecureRandom.urlsafe_base64(nil, false)
    token     = SecureRandom.urlsafe_base64(nil, false)

    user.tokens[client_id] = {
      token: BCrypt::Password.create(token),
      expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
    }

    user.save
    # UsersMailer.send_password(user.email, password).deliver
    return user
  end
end
