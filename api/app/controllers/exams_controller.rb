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

  def evaluate
    @exam = Exam.find(params[:exam_id])
    questions = params[:questions]

    score, question_ids = Exams::Evaluate.perform(questions, @exam.questions.length)

    if question_ids
      revision = Revision.create(exam_id: params[:exam_id], user_id: @user.id)
      revision.question_ids = question_ids
    end

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

  private

  def create_params
    params.permit(:title, :difficulty, :version, :category_id, :question_ids)
  end

  def index_params
    params.permit(:category)
  end
end
