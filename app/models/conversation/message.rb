# == Schema Information
#
# Table name: conversation_messages
#
#  id         :integer          not null, primary key
#  room_id    :integer
#  user_id    :integer
#  read       :boolean          default(FALSE)
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_conversation_messages_on_room_id  (room_id)
#  index_conversation_messages_on_user_id  (user_id)
#

class Conversation::Message < ApplicationRecord
  # Relations ------------------------------------------------------------------

  belongs_to :room, class_name: 'Conversation::Room'
  belongs_to :user

  # Validations ----------------------------------------------------------------

  validates_presence_of :text
end
