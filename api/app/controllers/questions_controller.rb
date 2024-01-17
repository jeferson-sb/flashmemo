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

    render json: { message: 'Question successfully deleted.' }, status: :no_content
  end

  def update
    @question = Question.find(params[:id])

    @question.image.attach(params[:image]) if question_update_params[:image].present?

    if @question.update(question_update_params)
      render json: @question, status: :ok
    else
      message = @question.errors.full_messages_for(:questions)
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def create
    @question = Question.new(create_params.slice(:title, :exam_id, :has_duo))
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
    params.permit(:title, :image)
  end

  def create_params
    params.permit(:title, :exam_id, :has_duo, options: %i[text correct])
  end
end
