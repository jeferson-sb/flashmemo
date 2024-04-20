# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Gardens', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe 'GET /' do
    before { create_list(:garden, 5) }

    it 'returns all gardens' do
      get '/api/gardens.json'

      expect(response).to be_successful
      expect(json_body.length).to eq(5)
    end
  end

  describe 'GET /:id' do
    before { create(:garden, id: 1) }

    it 'returns a garden successfully' do
      get '/api/gardens/1.json'

      expect(response).to have_http_status(:success)
      expect(json_body).to include('name')
      expect(json_body).to include('trees')
    end
  end

  describe 'POST /' do
    let(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    it 'creates a new garden successfully' do
      post '/api/gardens.json', headers: { 'Authorization' => "Bearer #{token}" }

      expect(response).to have_http_status(:success)
      expect(json_body).to include('message')
    end
  end
end
