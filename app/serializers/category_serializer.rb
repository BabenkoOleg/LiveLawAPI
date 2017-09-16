class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :prices, if: -> { should_render_prices }

  def should_render_prices
    @instance_options[:show_prices]
  end
end
