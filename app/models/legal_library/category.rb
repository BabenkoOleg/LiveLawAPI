# == Schema Information
#
# Table name: legal_library_categories
#
#  id                 :integer          not null, primary key
#  title              :string
#  parent_category_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class LegalLibrary::Category < ApplicationRecord
  # Relations ------------------------------------------------------------------

  belongs_to :parent_category, class_name: 'LegalLibrary::Category', required: false

  has_many :documents, class_name: 'LegalLibrary::Document'
  has_many :subcategories, class_name: 'LegalLibrary::Category', foreign_key: 'parent_category_id'
end
