class Api::GuestsController < ApplicationController
  def get_token
    while true
      token = SecureRandom.urlsafe_base64(nil, false)
      break unless Guest.find_by(token: token)
    end

    Guest.create(token: token)
    render json: { guest_token: token }
  end
end
