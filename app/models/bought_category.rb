# == Schema Information
#
# Table name: bought_categories
#
#  id                 :integer          not null, primary key
#  category_id        :integer
#  user_id            :integer
#  payment_expiration :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_bought_categories_on_category_id  (category_id)
#  index_bought_categories_on_user_id      (user_id)
#

class BoughtCategory < ApplicationRecord
  # Relations ------------------------------------------------------------------

  belongs_to :user
  belongs_to :category
end
