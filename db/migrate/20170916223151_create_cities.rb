class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :size
      t.belongs_to :region

      t.timestamps
    end
  end
end
