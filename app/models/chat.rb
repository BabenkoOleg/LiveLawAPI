# == Schema Information
#
# Table name: chats
#
#  id           :integer          not null, primary key
#  question     :string
#  asker_id     :integer
#  asker_type   :string
#  answerer_id  :integer
#  token        :string
#  category_id  :integer
#  city_id      :integer
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  invited_at   :datetime
#  name         :string
#  rejected_ids :integer          default([]), is an Array
#

class Chat < ApplicationRecord
  # Relations ------------------------------------------------------------------

  belongs_to :asker, polymorphic: true
  belongs_to :answerer, required: false, class_name: 'User'
  belongs_to :category
  belongs_to :city

  has_many :chat_messages

  # Fields ---------------------------------------------------------------------

  enum status: [
    :created,
    :bought,
    :invited,
    :chatting,
    :completed,
  ]

  # Methods --------------------------------------------------------------------

  def fresh?
    invited_at + 3.minutes > DateTime.now.utc
  end

  def send_message(message)
    ActionCable.server.broadcast("chat_#{token}_channel", message)
  end
end
