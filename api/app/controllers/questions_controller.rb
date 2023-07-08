class QuestionsController < ApplicationController
  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
  end

  def random
    @question = Question.all.sample
  end

  def update
    @question = Question.find(params[:id])

    if @question.update(question_update_params)
      render json: @question, status: :ok
    else
      render json: { error: @question.errors.message }, status: :unprocessable_entity
    end
  end

  private
    def question_update_params
      params.permit(:title)
    end
end
