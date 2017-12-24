class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :category, :charged, :created_at
  belongs_to :user, serializer: SimpleUserSerializer
  belongs_to :category, serializer: CategorySerializer

  def should_render_comments
    @instance_options[:show_comments]
  end
end
