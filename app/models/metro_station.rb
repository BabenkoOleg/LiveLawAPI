# == Schema Information
#
# Table name: metro_stations
#
#  id         :integer          not null, primary key
#  name       :string
#  city_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_metro_stations_on_city_id  (city_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#

class MetroStation < ApplicationRecord
  # Relations ------------------------------------------------------------------

  belongs_to :city
end
