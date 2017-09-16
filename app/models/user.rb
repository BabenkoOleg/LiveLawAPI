class User < ActiveRecord::Base
  # Includes -------------------------------------------------------------------

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable

  include DeviseTokenAuth::Concerns::User
  include UsersFilter

  # Fields ---------------------------------------------------------------------

  enum role: [:client, :lawyer, :jurist, :blocked]

  # Methods --------------------------------------------------------------------

  def full_name
    [last_name, first_name, middle_name].compact.join(' ')
  end

  def avatar_url
    avatar.try(:url)
  end
end
