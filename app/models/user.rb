# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  tokens                 :json
#  first_name             :string
#  last_name              :string
#  login                  :string
#  middle_name            :string
#  avatar                 :string
#  faculty                :string
#  fax                    :string
#  phone                  :string
#  staff                  :string
#  university             :string
#  work                   :string
#  active                 :boolean
#  email_public           :boolean
#  online                 :boolean          default(FALSE)
#  qualification          :boolean
#  date_of_graduation     :date
#  dob                    :date
#  online_time            :datetime
#  balance                :float
#  price                  :float
#  experience             :integer
#  role                   :integer
#  extends                :jsonb
#  userdata               :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

class User < ActiveRecord::Base
  # Includes -------------------------------------------------------------------

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable

  include DeviseTokenAuth::Concerns::User
  include UsersFilter

  mount_uploader :avatar, AvatarUploader

  # Relations ------------------------------------------------------------------

  has_many :questions
  has_many :bought_categories
  has_many :categories, through: :bought_categories

  has_and_belongs_to_many :cities

  # Fields ---------------------------------------------------------------------

  enum role: [:client, :lawyer, :jurist, :blocked]

  # Methods --------------------------------------------------------------------

  class << self
    def random_password
      Devise.friendly_token[0,20]
    end
  end

  def full_name
    [last_name, first_name, middle_name].compact.join(' ')
  end

  def avatar_url
    avatar.try(:url)
  end
end
