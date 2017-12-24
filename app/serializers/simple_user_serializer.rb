class SimpleUserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :avatar_url, :online, :role, :city_name
end
