class ExamsController < ApplicationController
  def show
    @exam = Exam.find(params[:id])
  end

  def evaluate
    @exam = Exam.find(params[:exam_id])
    questions = params[:questions]

    pts = 0.0
    total = @exam.questions.length
    
    questions.each do |question|
      option = Option.where(question_id: question[:id], correct: true).first

      if option.id == question[:option_id]
        pts += 1.0
      end
    end
    
    render json: { score: (pts / total) * 100 }, status: :created
  end
end
