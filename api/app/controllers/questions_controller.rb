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
    options = params[:options]

    options.each do |option|
      @question.options.new(text: option[:text], correct: option[:correct])
    end

    if @question.save
      render json: { message: "Question successfully created" }, status: :created
    else
      message = @question.errors.full_messages_for(:options)
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.permit(:title, :options, :exam_id)
  end
end
