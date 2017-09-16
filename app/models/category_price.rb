# == Schema Information
#
# Table name: category_prices
#
#  id          :integer          not null, primary key
#  category_id :integer
#  day_1       :integer          default(0)
#  day_3       :integer          default(0)
#  day_7       :integer          default(0)
#  month_1     :integer          default(0)
#  month_3     :integer          default(0)
#  month_6     :integer          default(0)
#  month_12    :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_category_prices_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#

class CategoryPrice < ApplicationRecord
  # Constants ------------------------------------------------------------------

  TIME_SPANS = {
    day_1:    '1 день',
    day_3:    '3 дня',
    day_7:    '7 дней',
    month_1:  '1 месяц',
    month_3:  '3 месяца',
    month_6:  '6 месяцев',
    month_12: '12 месяцев'
  }.freeze

  # Relations ------------------------------------------------------------------

  belongs_to :category
end

