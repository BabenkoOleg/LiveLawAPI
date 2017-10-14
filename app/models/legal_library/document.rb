# == Schema Information
#
# Table name: legal_library_documents
#
#  id          :integer          not null, primary key
#  title       :string
#  body        :text
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class LegalLibrary::Document < ApplicationRecord
  # Relations ------------------------------------------------------------------

  belongs_to :category, class_name: 'LegalLibrary::Category'
end
