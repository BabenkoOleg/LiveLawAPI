class CreateLegalLibraryCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :legal_library_categories do |t|
      t.string :title
      t.integer :parent_category_id

      t.timestamps
    end
  end
end
