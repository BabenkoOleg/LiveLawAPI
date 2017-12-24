class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :avatar_url, :active, :role, :last_name,
             :middle_name, :email_public, :phone, :experience, :qualification,
             :price, :university, :faculty, :date_of_graduation, :work, :staff,
             :dob, :balance, :online, :created_at, :updated_at, :online_time,
             :login, :fax, :userdata, :extends, :full_name, :chat_status, :cities

  attribute :chat_token, if: -> { should_render_chat_token }

  def should_render_chat_token
    object.invited?
  end
end
