class CreateCategoryPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :category_prices do |t|
      t.belongs_to :category, foreign_key: true

      t.integer :day_1,    default: 0
      t.integer :day_3,    default: 0
      t.integer :day_7,    default: 0
      t.integer :month_1,  default: 0
      t.integer :month_3,  default: 0
      t.integer :month_6,  default: 0
      t.integer :month_12, default: 0

      t.timestamps
    end
  end
end

