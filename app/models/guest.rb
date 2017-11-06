# == Schema Information
#
# Table name: guests
#
#  id         :integer          not null, primary key
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Guest < ApplicationRecord

  # Methods --------------------------------------------------------------------

  def specialist?
    false
  end

  def chat_token
    Chat.where(asker_id: id).last.try(:token)
  end

  def active_chat
    Chat.where(asker_id: id).last
  end
end
