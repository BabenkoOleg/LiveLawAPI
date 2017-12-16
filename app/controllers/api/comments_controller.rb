class Api::CommentsController < ApplicationController
  before_action :set_question, only: [:index, :create]

  # GET /questions/:id/comment
  def index
    comments = @question.comments.page(params[:page] || 1)
    render json: comments, include: '*'
  end

  private

  def set_question
    @question = Question.find_by(id: params[:question_id])

    if @question.nil?
      render json: { error: 'The question was not found' }, status: :not_found
    end
  end
end
