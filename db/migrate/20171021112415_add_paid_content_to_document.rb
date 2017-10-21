class AddPaidContentToDocument < ActiveRecord::Migration[5.1]
  def change
    rename_column :legal_library_documents, :body, :free_content
    add_column :legal_library_documents, :paid_content, :text
  end
end
