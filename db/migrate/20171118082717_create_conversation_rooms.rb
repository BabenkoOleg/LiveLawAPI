class CreateConversationRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :conversation_rooms do |t|

      t.timestamps
    end
  end
end
