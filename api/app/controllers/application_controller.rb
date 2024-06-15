# frozen_string_literal: true

class ApplicationController < ActionController::API
  around_action :switch_locale

  def switch_locale(&action)
    locale = extract_locale_from_accept_language_header || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  private

  def extract_locale_from_accept_language_header
    return unless request.env['HTTP_ACCEPT_LANGUAGE'].present?

    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

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
