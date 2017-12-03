# == Schema Information
#
# Table name: conversation_messages
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  dialog_id    :integer
#  read         :boolean          default(FALSE)
#  text         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_conversation_messages_on_dialog_id     (dialog_id)
#  index_conversation_messages_on_recipient_id  (recipient_id)
#  index_conversation_messages_on_sender_id     (sender_id)
#

class Conversation::Message < ApplicationRecord
  # Relations ------------------------------------------------------------------

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  # Validations ----------------------------------------------------------------

  validates_presence_of :text
end
