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
end
