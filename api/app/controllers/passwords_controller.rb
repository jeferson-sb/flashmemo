class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ update ]

  def create
    return render json: { error: 'Email is required' }, status: :bad_request if params[:email].blank?

    if user = User.find_by(email: params[:email])
      PasswordsMailer.reset(user).deliver_later
    end

    render json: { message: 'Password reset instructions sent' }
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      @user.sessions.destroy_all
      render json: { message: 'Password has been reset.' }
    else
      render json: { error: 'Passwords did not match.' }, status: :unprocessable_entity
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_password_reset_token!(params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    render json: { errors: ['Password reset link is invalid or has expired.'] }, status: :unauthorized
  end
end
