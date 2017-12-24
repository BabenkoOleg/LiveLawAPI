class Api::QuestionsController < ApplicationController
  # GET /questions
  def index
    questions = Question.filter_by(params)
    render json: {
      page: questions.current_page,
      total: questions.total_count,
      questions: questions
    }
  end

  # GET /questions/1
  def show
    question = Question.find(params[:id])
    render json: as_json_without_root(question, show_comments: true)
  end

  # POST /questions
  def create
    user = current_api_user || register_user(user_params)
    question = user.questions.build(question_params)

    if question.save
      render json: as_json_without_root(question), status: :created
    else
      render json: question.errors, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question)
          .permit(:title, :text, :category_id,
                  file_containers_attributes: %w[
                    file @original_filename @content_type @headers _destroy id
                  ])
  end

  def user_params
    params.require(:user).permit(:email, :city_id, :first_name)
  end
end
