# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_request, except: [:create]

  MONTH = { january: 1, june: 6, july: 7, december: 12 }.freeze

  def create
    @user = User.new(create_params)

    if @user.save
      render json: { message: I18n.t('success.created', entity: User.model_name.human) }, status: :created
    else
      message = @user.errors
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def progress
    @answers = Answers::InRange.perform(params[:user_id], params[:time])

    if !@answers.empty?
      average, exams = Users::Progress.perform(@answers)

      render json: { average:, exams: }, status: :ok
    else
      render json: { error: I18n.t('error.not_found_entities', entity: Answer.model_name.human(count: 2)) },
             status: :not_found
    end
  end

  private

  def create_params
    params.permit(:name, :username, :email, :password)
  end
end
