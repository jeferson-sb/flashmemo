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

    return if @question

    render json: { message: I18n.t('not_avaliable', entity: Question.model_name.human(count: 2)) }
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    render json: { message: I18n.t('success.deleted', entity: Question.model_name.human) }, status: :no_content
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
      render json: { message: I18n.t('success.created', entity: Question.model_name.human) }, status: :created
    else
      message = @question.errors.full_messages_for(:options)
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def bulk
    questions = bulk_params[:questions]

    begin
      bulk_create_questions(questions)
      render json: { message: I18n.t('success.created', entity: Question.model_name.human(count: 2)) }, status: :created
    rescue StandardError => e
      render json: { error: I18n.t('failed.creation', entity: Question.model_name.human(count: 2)), reason: e.message },
             status: :bad_request
    end
  end

  private

  def question_update_params
    params.permit(:title, :image)
  end

  def create_params
    params.permit(:title, :exam_id, :has_duo, options: %i[text correct])
  end

  def bulk_params
    params.permit(questions: [:title, { options: %i[text correct] }])
  end

  def bulk_create_questions(questions)
    Questions::Bulk.create(questions)
  end
end
