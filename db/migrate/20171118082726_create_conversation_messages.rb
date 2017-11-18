class CreateConversationMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :conversation_messages do |t|
      t.integer :room_id, index: true
      t.integer :user_id, index: true
      t.boolean :read, default: false
      t.string :text

      t.timestamps
    end
  end
end
