# frozen_string_literal: true

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

  def update
    @question = Question.find(params[:id])

    if @question.update(question_update_params)
      render json: @question, status: :ok
    else
      render json: { error: @question.errors.message }, status: :unprocessable_entity
    end
  end

  def create
    @question = Question.new(title: create_params[:title], exam_id: create_params[:exam_id])
    @question.options.build(create_params[:options])

    if @question.save
      render json: { message: 'Question successfully created' }, status: :created
    else
      message = @question.errors.full_messages_for(:options)
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  private

  def question_update_params
    params.permit(:title)
  end

  def create_params
    params.permit(:title, :exam_id, options: %i[text correct])
  end
end
