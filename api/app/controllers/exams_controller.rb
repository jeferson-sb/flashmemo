# frozen_string_literal: true

class ExamsController < ApplicationController
  before_action :authenticate_request, only: :evaluate

  def show
    @exam = Exam.find(params[:id])
  end

  def index
    @exams = Exam.by_category(index_params[:category])
    render json: @exams
  end

  # Evaluates an exam
  # FindOrCreate revision (if missed questions)
  # Store the final answer for the user
  def evaluate
    @exam = Exam.find(params[:exam_id])
    questions = params[:questions]

    score, questions_answered_incorrectly = Exams::Evaluate.perform(questions, @exam.questions.length)
    Revisions::Create.perform(params[:exam_id], @user.id, questions_answered_incorrectly)
    answer = Answer.find_or_create_by(
      exam_id: params[:exam_id], 
      user_id: @user.id, 
      score:
    )
    answer.attempt

    render json: { score: }, status: :created
  end

  def create
    @exam = Exam.new(create_params.slice(:title, :difficulty, :version, :category_id))

    if @exam.save
      questions = params[:question_ids]
      questions.each do |question_id|
        @question = Question.update(question_id, exam_id: @exam.id)
        @exam.questions << @question
      end

      render json: { message: 'Exam successfully created.' }, status: :created
    else
      message = @exam.errors
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def duos
    @exam = Exam.find(params[:exam_id])
    duos = Questions::Duos.duos(@exam.questions)

    render json: { title: 'Match the duos', duos: }
  end

  def evaluate_duos
    ans = Questions::Duos.evaluate(params[:duos])
    if ans
      render json: { message: 'Well done!' }
    else
      render json: { message: 'Oops, try again!' }, status: :bad_request
    end
  end

  private

  def create_params
    params.permit(:title, :difficulty, :version, :category_id, :question_ids)
  end

  def index_params
    params.permit(:category)
  end
end
