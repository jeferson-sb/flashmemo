class ExamsController < ApplicationController
  def show
    @exam = Exam.find(params[:id])
  end

  def evaluate
    @exam = Exam.find(params[:exam_id])
    questions = params[:questions]

    score, error = Exams::Evaluate.perform(questions, @exam.questions.length)

    if error
      render json: { error: { message: error } }, status: :unprocessable_entity
    else
      render json: { score: }, status: :created
    end
  end
end
