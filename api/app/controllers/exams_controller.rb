# frozen_string_literal: true

class ExamsController < ApplicationController
  def show
    @exam = Exam.find(params[:id])
  end

  def evaluate
    @exam = Exam.find(params[:exam_id])
    questions = params[:questions]

    score = Exams::Evaluate.perform(questions, @exam.questions.length)

    render json: { score: }, status: :created
  end

  def create
    @exam = Exam.new(create_params.slice(:title, :difficulty, :version))

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
    params.permit(:title, :difficulty, :version, :question_ids)
  end
end
