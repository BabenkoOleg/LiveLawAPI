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
end
