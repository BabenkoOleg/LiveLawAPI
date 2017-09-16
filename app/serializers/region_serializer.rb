class RegionSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :cities, if: -> { should_render_cities }

  def should_render_cities
    @instance_options[:show_cities]
  end
end
