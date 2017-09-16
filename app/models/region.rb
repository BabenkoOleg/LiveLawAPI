# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Region < ApplicationRecord
  # Includes -------------------------------------------------------------------

  include CitiesFilter

  # Relations ------------------------------------------------------------------

  has_many :cities
end
