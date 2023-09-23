# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.new(create_params.slice(:username, :email))

    if @user.save
      render json: { message: 'User successfully created.' }, status: :created
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
      render json: { error: 'No answers found for this user.' }, status: :not_found
    end
  end

  private

  def create_params
    params.permit(:username, :email)
  end

  def get_semester_dates(today)
    if today.month >= 7
      [Date.new(today.year, 1).beginning_of_month, Date.new(today.year, 6).end_of_month]
    else
      [Date.new(today.year - 1, 7).beginning_of_month, Date.new(today.year - 1, 12).end_of_month]
    end
  end

  def get_answers(user_id, period)
    today = Time.now

    start_date, end_date =
      case period
      when 'monthly'
        [today - 30.days, nil]
      when 'yearly'
        [today - 1.year, nil]
      when 'semester'
        get_semester_dates(today)
      else
        [nil, nil]
      end

    Answer.where(user_id:, created_at: start_date..end_date)
  end
end
