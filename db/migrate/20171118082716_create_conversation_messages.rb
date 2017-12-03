class CreateConversationMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :conversation_messages do |t|
      t.integer :sender_id, index: true
      t.integer :recipient_id, index: true

      t.integer :dialog_id, index: true

      t.boolean :read, default: false
      t.string :text

      t.timestamps
    end
  end
end
