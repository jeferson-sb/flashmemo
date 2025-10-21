# frozen_string_literal: true

class ExamsController < ApplicationController
  allow_unauthenticated_access only: %i[index show duos]

  def show
    @exam = Exam.find(params[:id])
  end

  def index
    @exams = Exam.by_category(index_params[:category])
    render json: @exams
  end

  def evaluate
    @exam = Exam.find(params[:exam_id])
    @user = Current.session.user
    questions = params[:questions]

    score, questions_answered_incorrectly = get_results(@exam, questions)

    begin
      create_revision_if_needed(@exam.id, @user.id, questions_answered_incorrectly)
      answer = create_answer(@exam.id, @user.id, score)
      earn_rewards(answer, @user)

      render json: { score: }, status: :created
    rescue StandardError => e
      render json: { error: I18n.t('error.failed_evaluate', reason: e.message) }, status: :bad_request
    end
  end

  def create
    @exam = Exam.new(create_params.slice(:title, :difficulty, :version, :category_id))

    if @exam.save
      questions = params[:question_ids]
      questions.each do |question_id|
        @question = Question.update(question_id, exam_id: @exam.id)
        @exam.questions << @question
      end

      render json: { message: I18n.t('success.created', entity: Exam.model_name.human) }, status: :created
    else
      message = @exam.errors
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def update
    @exam = Exam.find(params[:id])

    if @exam.update(create_params.slice(:title, :difficulty, :version, :category_id))
      render json: @exam, status: :ok
    else
      message = @exam.errors.full_messages
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy

    render json: { message: I18n.t('success.deleted', entity: Exam.model_name.human) }, status: :no_content
  end

  def duos
    @exam = Exam.find(params[:exam_id])
    duos = Questions::Duos.duos(@exam.questions)

    render json: { title: I18n.t('match_the_duos'), duos: }
  end

  def evaluate_duos
    ans = Questions::Duos.evaluate(params[:duos])
    if ans
      render json: { message: I18n.t('well_done') }
    else
      render json: { message: I18n.t('try_again') }, status: :bad_request
    end
  end

  private

  def create_params
    params.permit(:title, :difficulty, :version, :category_id, :question_ids)
  end

  def index_params
    params.permit(:category)
  end

  def get_results(exam, questions)
    Exams::Evaluate.perform(questions, exam.questions.length)
  end

  def create_revision_if_needed(exam_id, user_id, questions_answered_incorrectly)
    Revisions::Create.perform(exam_id, user_id, questions_answered_incorrectly)
  end

  def create_answer(exam_id, user_id, score)
    Answers::Create.perform(exam_id, user_id, score)
  end

  def earn_rewards(last_answer, user)
    Rewards::Earn.perform(last_answer, user)
  end
end
