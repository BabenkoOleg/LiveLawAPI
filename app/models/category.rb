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

  has_many :bought_categories
  has_many :users, through: :bought_categories

  # Callbacks ------------------------------------------------------------------

  after_commit :create_prices, on: [:create]

  # Methods --------------------------------------------------------------------

  def bought?(user)
    bought = bought_categories.find_by(user_id: user.id)
    return false if bought.nil?
    return bought.delete && false if DateTime.now >= bought.payment_expiration
    true
  end

  private

  def create_category_subscriptions
    self.price = Proce.create
  end
end
