# frozen_string_literal: true

class RevisionsController < ApplicationController
  before_action :authenticate_request

  def show
    @revision = Revision.find(params[:id])
  end

  def evaluate
    questions = params[:questions]
    @revision = Revision.find(params[:revision_id])

    score, = Exams::Evaluate.perform(questions, @revision.questions.length)

    render json: { score: }, status: :created
  end
end
