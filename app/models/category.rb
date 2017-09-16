# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ApplicationRecord
  # Relations ------------------------------------------------------------------

  has_one :prices, class_name: 'CategoryPrice'

  # Callbacks ------------------------------------------------------------------

  after_commit :create_prices, on: [:create]

  # Methods --------------------------------------------------------------------

  private

  def create_category_subscriptions
    self.price = Proce.create
  end
end
