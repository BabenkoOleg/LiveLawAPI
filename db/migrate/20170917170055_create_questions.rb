class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string     :title
      t.text       :text
      t.boolean    :charged, default: false
      t.belongs_to :category, index: true
      t.belongs_to :user,     index: true

      t.timestamps
    end
  end
end

