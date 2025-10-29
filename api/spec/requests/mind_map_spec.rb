# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MindMaps', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end
  let!(:user) { create(:user) }

  describe 'GET /' do
    before { create(:mind_map) }

    it 'returns all mindmaps' do
      get '/api/mindmaps.json', headers: auth_headers

      expect(response).to be_successful
    end
  end

  describe 'GET /:id' do
    let(:mind_map) { create(:mind_map) }

    it 'returns a mindmap' do
      get "/api/mindmaps/#{mind_map.id}.json", headers: auth_headers

      expect(response).to be_successful
      expect(json_body).to include('name')
      expect(json_body).to include('owner_id')
    end
  end

  describe 'POST /' do
    describe 'when connections are empty' do
      let(:params) do
        {
          name: Faker::Lorem.sentence,
          connections: []
        }
      end

      it 'returns an error message' do
        post('/api/mindmaps.json', params:, headers: auth_headers, as: :json)

        expect(response).to have_http_status(:bad_request)
        expect(json_body).to include('error')
      end
    end
  end
end
