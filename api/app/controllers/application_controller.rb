# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def authenticate_request
    token = extract_token_from_header

    begin
      @decoded = JsonWebToken.decode(token)
      @user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def extract_token_from_header
    header = request.headers['Authorization']
    header&.split(' ')&.last
  end
end
