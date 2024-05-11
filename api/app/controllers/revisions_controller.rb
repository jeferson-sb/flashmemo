# frozen_string_literal: true

class RevisionsController < ApplicationController
  before_action :authenticate_request

  def show
    @revision = Revision.find(params[:id])
  end

  def evaluate
    questions = params[:questions]
    @revision = Revision.find(params[:revision_id])

    begin
      score, = get_results(@revision, questions)
      answer = create_answer(@revision.exam.id, @user.id, score)
      earn_rewards(answer, @user)
      
      @revision.increment_interval
      render json: { score: }, status: :created
    rescue Exception => e
      render json: { error: "Failed to evalute your test: #{e.message}" }, status: :bad_request
    end
  end

  private

  def create_answer(exam_id, user_id, score)
    Answers::Create.perform(exam_id, user_id, score)
  end

  def get_results(revision, questions)
    Exams::Evaluate.perform(questions, revision.questions.length)
  end

  def earn_rewards(last_answer, user)
    Rewards::Earn.perform(last_answer, user, true)
  end
end
