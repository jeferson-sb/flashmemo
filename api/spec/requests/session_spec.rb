# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe 'POST /sessions' do
    let!(:user) { create(:user) }

    it 'return a new session token' do
      post '/api/sessions.json', params: { email: user.email, password: user.password }

      expect(response).to have_http_status(:success)
      expect(json_body).to include('token')
    end
  end

  describe 'DELETE /sessions' do
    it 'revokes the session token' do
      delete '/api/sessions.json', headers: auth_headers

      expect(response).to have_http_status(:success)
      expect(json_body['message']).to eq('Logged out')
    end
  end
end
