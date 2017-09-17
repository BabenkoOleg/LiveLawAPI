class CreateBoughtCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :bought_categories do |t|
      t.belongs_to :category, index: true
      t.belongs_to :user,     index: true

      t.datetime   :payment_expiration

      t.timestamps
    end
  end
end
