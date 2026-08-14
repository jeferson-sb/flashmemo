# frozen_string_literal: true

class QuestionsController < ApplicationController
  allow_unauthenticated_access only: %i[index show random]

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
    @question = owned_questions.find(params[:id])
    @question.destroy

    render json: { message: I18n.t('success.deleted', entity: Question.model_name.human) }, status: :no_content
  end

  def update
    @question = owned_questions.find(params[:id])

    @question.image.attach(params[:image]) if question_update_params[:image].present?

    if @question.update(question_update_params)
      render json: @question, status: :ok
    else
      message = @question.errors.full_messages_for(:questions)
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def create
    exam = requested_exam
    @question = Question.new(create_params.slice(:title, :exam_id, :has_duo))
    @question.options.build(create_params[:options])

    if @question.save
      exam.questions << @question if exam

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

  # Every reader of an exam's questions — the jbuilder views, Exams::Evaluate,
  # Questions::Duos — goes through the habtm association, so writing only the
  # legacy questions.exam_id column leaves the new question invisible. Resolved
  # before the question is saved so an exam that isn't yours 404s instead of
  # orphaning a question.
  def requested_exam
    return if create_params[:exam_id].blank?

    Exam.owned_by(Current.user.id).find(create_params[:exam_id])
  end

  # A question is editable through the exams it belongs to. Questions attached
  # to no exam are nobody's, and stay read-only.
  def owned_questions
    Question.joins(:exams).where(exams: { user_id: Current.user.id }).distinct
  end

  def question_update_params
    params.permit(:title, :image)
  end

  def create_params
    params.permit(:title, :exam_id, :has_duo, :is_limited_between, options: %i[text correct])
  end

  def bulk_params
    params.permit(questions: [:title, { options: %i[text correct] }])
  end

  def bulk_create_questions(questions)
    Questions::Bulk.create(questions)
  end
end
