# == Schema Information
#
# Table name: conversation_rooms
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Conversation::Room < ApplicationRecord
  # Relations ------------------------------------------------------------------

  has_many :messages, class_name: 'Conversation::Message'

  has_and_belongs_to_many :users
end
