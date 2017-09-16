class CitySerializer < ActiveModel::Serializer
  attributes :id, :name, :region_name
  has_many :metro_stations
end
