class CreateConversationDialog < ActiveRecord::Migration[5.1]
  def change
    create_table :conversation_dialogs do |t|
      t.integer :user_1_id, index: true
      t.integer :user_2_id, index: true
    end
  end
end
