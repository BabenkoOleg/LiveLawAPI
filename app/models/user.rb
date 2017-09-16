class User < ActiveRecord::Base
  # Include default devise modules.
  # :omniauthable, :confirmable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  enum role: [:client, :lawyer, :jurist, :blocked]

  def full_name
    [last_name, first_name, middle_name].compact.join(' ')
  end

  def avatar_url
    avatar.try(:url)
  end
end
