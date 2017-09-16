class CategoryPriceSerializer < ActiveModel::Serializer
  attributes *CategoryPrice::TIME_SPANS.keys
end
