class AddRejectedIdsToChat < ActiveRecord::Migration[5.1]
  def change
    add_column :chats, :rejected_ids, :integer, array: true, default: []
  end
end
