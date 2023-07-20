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

  def create
    @question = Question.new(title: create_params[:title], exam_id: create_params[:exam_id])
    @question.options.build(create_params[:options])

    if @question.save
      render json: { message: "Question successfully created" }, status: :created
    else
      message = @question.errors.full_messages_for(:options)
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.permit(:title, :exam_id, options: [:text, :correct])
  end
end
