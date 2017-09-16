class CreateCitiesUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :cities_users, id: false do |t|
      t.belongs_to :city, foreign_key: true
      t.belongs_to :user, foreign_key: true
    end
  end
end
