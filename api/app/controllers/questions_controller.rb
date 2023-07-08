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

  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    render json: { message: "Question successfully deleted." }, status: :no_content
  end
end
