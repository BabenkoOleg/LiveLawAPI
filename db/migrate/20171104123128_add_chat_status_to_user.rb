class AddChatStatusToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :chat_status, :integer, default: 0
  end
end
