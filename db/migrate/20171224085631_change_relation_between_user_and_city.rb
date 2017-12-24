class ChangeRelationBetweenUserAndCity < ActiveRecord::Migration[5.1]
  def change
    drop_table :cities_users
    add_column :users, :city_id, :integer
  end
end
