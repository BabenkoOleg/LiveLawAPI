class CreateLegalLibraryDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :legal_library_documents do |t|
      t.string :title
      t.text :body
      t.integer :category_id

      t.timestamps
    end
  end
end
