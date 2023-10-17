# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe 'POST /auth/login' do
    let(:user) { create(:user) }
    let(:params) do
      {
        email: user.email,
        password: user.password
      }
    end

    it 'log in user' do
      post('/api/auth/login', params:)

      expect(response).to be_successful
    end
  end
end
