class Api::QuestionsController < ApplicationController
  # GET /questions
  def index
    @questions = Question.filter_by(params)

    if params[:page].present?
      pagination = {
        total_count: @questions.total_count,
        current_page: @questions.current_page
      }
      collection =
        ActiveModelSerializers::SerializableResource.new(@questions, {}).as_json

      render json: { result: collection , pagination: pagination }
    else
      render json: @questions
    end
  end

  # GET /questions/1
  def show
    @question = Question.find(params[:id])
    render json: @question, show_comments: true
  end

  # POST /questions
  def create
    user = current_user || register_user
    @question = user.questions.build(question_params)

    if @question.save
      render json: @question, status: :created
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question)
          .permit(:title, :text, :category_id,
                  file_containers_attributes: ['file', '@original_filename',
                                               '@content_type', '@headers',
                                               '_destroy', 'id'])
  end

  def user_params
    params.require(:user).permit(:email, :city_id, :first_name)
  end
end
