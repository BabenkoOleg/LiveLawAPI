class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :user, :category, :charged, :created_at
  # has_many :comments, if: -> { should_render_comments }

  def should_render_comments
    @instance_options[:show_comments]
  end
end