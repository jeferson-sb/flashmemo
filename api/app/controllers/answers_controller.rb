# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_request

  def show
    @answer = Answer.find(params[:id])

    render json: @answer
  end

  def create
    @answer = Answer.new(create_params)

    if @answer.save
      render json: { message: I18n.t('success.created', entity: Answer.model_name.human) }, status: :created
    else
      message = @answer.errors
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.permit(:exam_id, :user_id, :score)
  end
end
