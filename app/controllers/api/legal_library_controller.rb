class Api::LegalLibraryController < ApplicationController
  def index
    categories = LegalLibrary::Category.where(parent_category: nil)
    data = ActiveModelSerializers::SerializableResource.new(categories, {})
    render json: { categories: data.as_json["legal_library/categories".to_sym] }
  end

  def categories
    category = LegalLibrary::Category.find(params[:id])
    data = ActiveModelSerializers::SerializableResource.new(category, {})
    render json: { category: data.as_json["legal_library/category".to_sym] }
  end

  def documents
    document = LegalLibrary::Document.find(params[:id])
    data = LegalLibrary::DocumentSerializer.new(document, { show_details: true })
    render json: { document: data }
  end
end
