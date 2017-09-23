class CreateChatMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_messages do |t|
      t.string :text

      t.integer :sender_id
      t.string  :sender_type

      t.belongs_to :chat, index: true

      t.timestamps
    end
  end
end
