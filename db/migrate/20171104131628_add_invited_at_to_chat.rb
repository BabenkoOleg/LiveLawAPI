class AddInvitedAtToChat < ActiveRecord::Migration[5.1]
  def change
    add_column :chats, :invited_at, :datetime
  end
end
