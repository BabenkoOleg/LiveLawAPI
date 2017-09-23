class CreateChats < ActiveRecord::Migration[5.1]
  def change
    create_table :chats do |t|
      t.string  :question

      t.integer :asker_id
      t.string  :asker_type
      t.integer :answerer_id

      t.string  :token
      t.integer :category_id
      t.integer :city_id

      t.integer :status

      t.timestamps
    end
  end
end
