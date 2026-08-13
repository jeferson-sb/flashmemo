class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email, :password))
      start_new_session_for user
      render json: { token: Current.session.token }
    else
      render json: { error: 'Invalid email address or password' }, status: :unauthorized
    end
  end

  def show
    user = Current.session.user
    render json: { id: user.id, name: user.name, username: user.username, email: user.email }
  end

  def destroy
    terminate_session
    render json: { message: 'Logged out' }, status: :ok
  end
end
