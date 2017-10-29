# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  text             :string
#  user_id          :integer
#  commentable_type :string
#  commentable_id   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_user_id                              (user_id)
#

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :comments, as: :commentable, dependent: :destroy

  before_save :check_for_too_nested

  private

  def check_for_too_nested
    if commentable.present? &&
       commentable.class.to_s.downcase == 'comment' &&
       commentable.commentable_type.to_s.downcase == "comment"

      errors.add(:base, 'The maximum depth of comments is 2')
      throw :abort
    end
  end
end
