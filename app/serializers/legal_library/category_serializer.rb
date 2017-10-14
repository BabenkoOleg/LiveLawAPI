class LegalLibrary::CategorySerializer < ActiveModel::Serializer
  attributes :id, :title
  has_many :subcategories, if: -> { @object.subcategories.any? }
  has_many :documents, if: -> { @object.documents.any? }
end
