class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at
  attribute :comments, if: -> { should_render_comments }
  belongs_to :user, serializer: SimpleUserSerializer

  def should_render_comments
    object.commentable_type == 'Question'
  end

  def comments
    object.comments.map do |comment|
      ActiveModelSerializers::SerializableResource.new(comment).as_json[:comment]
    end
  end
end
