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

  private

  def create_params
    params.permit(:username, :email)
  end
end
