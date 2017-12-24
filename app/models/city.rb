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
# Foreign Keys
#
#  fk_rails_...  (region_id => regions.id)
#

class City < ApplicationRecord
  # Includes -------------------------------------------------------------------

  include CitiesFilter

  # Relations ------------------------------------------------------------------

  belongs_to :region

  has_many :users
  has_many :metro_stations

  # Delegates ------------------------------------------------------------------

  delegate :name, to: :region, prefix: :region
end
