# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string
#  size       :integer
#  region_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_cities_on_region_id  (region_id)
#

class City < ApplicationRecord
  # Relations ------------------------------------------------------------------

  belongs_to :region
end
