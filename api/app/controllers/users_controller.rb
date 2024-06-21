# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_request, except: [:create]

  MONTH = { january: 1, june: 6, july: 7, december: 12 }.freeze

  def create
    @user = User.new(create_params)

    if @user.save
      render json: { message: I18n.t('success.failed_evaluate', entity: User.model_name.human) }, status: :created
    else
      message = @user.errors
      render json: { error: message }, status: :unprocessable_entity
    end
  end

  def progress
    @answers = get_answers(params[:user_id], params[:time])

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

  def get_semester_dates(date)
    if date.month >= MONTH[:july]
      [Date.new(date.year, MONTH[:january]).beginning_of_month, Date.new(date.year, MONTH[:june]).end_of_month]
    else
      [Date.new(1.year.ago.year, MONTH[:july]).beginning_of_month,
       Date.new(1.year.ago.year, MONTH[:december]).end_of_month]
    end
  end

  def get_dates(period)
    current_date = Time.now

    case period
    when 'monthly'
      [30.days.ago, nil]
    when 'yearly'
      [1.year.ago, nil]
    when 'semester'
      get_semester_dates(current_date)
    else
      [nil, nil]
    end
  end

  def get_answers(user_id, period)
    start_date, end_date = get_dates(period)

    Answer.where(user_id:, created_at: start_date..end_date)
  end
end
