class Api::CommentsController < ApplicationController
  before_action :authenticate_api_user!, only: [:create]
  before_action :set_question, only: [:index, :create]

  # GET /questions/:id/comments
  def index
    comments = @question.comments.page(params[:page] || 1)
    render json: comments, include: '*'
  end

  # POST /questions/:id/comments
  def create
    if current_api_user.client? && current_api_user != @question.user
      return render json: {
        error: 'You can not comment on another user\'s question'
      }, status: :forbidden
    end

    if params[:parent_id].present?
      parent = Comment.find(params[:parent_id])
      comment = parent.comments.new(comment_params)
    else
      comment = @question.comments.new(comment_params)
    end

    comment.user = current_api_user

    if comment.save
      render json: comment, status: :created
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def set_question
    @question = Question.find_by(id: params[:question_id])

    if @question.nil?
      render json: { error: 'The question was not found' }, status: :not_found
    end
  end
end
