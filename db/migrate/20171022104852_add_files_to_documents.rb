class AddFilesToDocuments < ActiveRecord::Migration[5.1]
  def change
    add_column :legal_library_documents, :file, :string
  end
end
