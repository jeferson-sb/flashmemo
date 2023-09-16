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
    @answers = Answer.where(user_id: params[:user_id])

    if !@answers.empty?
      average, exams = Users::Progress.perform(@answers)

      render json: { average:, exams: }, status: :ok
    else
      render json: { error: 'No answers found for this user.' }
    end
  end

  private

  def create_params
    params.permit(:username, :email)
  end
end
