module QuestionsFilter
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by(params)
      questions = Question.page(params[:page] || 1).per(params[:per_page] || 20)
      questions = questions.where('(title||text) ~* ?', params[:query]) if params[:query]
      questions = questions.where(category_id: params[:category]) if params[:category]

      return questions
    end
  end
end
