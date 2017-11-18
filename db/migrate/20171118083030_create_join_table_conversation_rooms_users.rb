class CreateJoinTableConversationRoomsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :conversation_rooms_users, id: false do |t|
      t.integer :room_id, index: true
      t.integer :user_id, index: true
    end
  end
end
