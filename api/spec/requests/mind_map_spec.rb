# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MindMaps', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end
  let!(:user) { create(:user) }
  let!(:token) { JsonWebToken.encode(user_id: user.id) }

  describe 'GET /' do
    before { create(:mind_map) }

    it 'returns all mindmaps' do
      get '/api/mindmaps.json', headers: { 'Authorization' => "Bearer #{token}" }

      expect(response).to be_successful
    end
  end

  describe 'GET /:id' do
    let(:mind_map) { create(:mind_map) }

    it 'returns a mindmap' do
      get "/api/mindmaps/#{mind_map.id}.json", headers: { 'Authorization' => "Bearer #{token}" }

      expect(response).to be_successful
      expect(json_body).to include('name')
      expect(json_body).to include('nodes')
    end
  end

  describe 'POST /' do
    let!(:category) { create(:category) }
    let!(:exams) { create_list(:exam, 3) }

    describe 'when edges are NOT empty' do
      let(:params) do
        {
          name: Faker::Lorem.sentence,
          category_id: category.id,
          edges: [
            [exams[0].id, exams[1].id]
          ]
        }
      end

      it 'creates a new mind map' do
        post('/api/mindmaps.json', params:, headers: { 'Authorization' => "Bearer #{token}" }, as: :json)

        expect(response).to have_http_status(:success)
      end
    end

    describe 'when edges are empty' do
      let(:params) do
        {
          name: Faker::Lorem.sentence,
          category_id: category.id,
          edges: []
        }
      end

      it 'returns an error message' do
        post('/api/mindmaps.json', params:, headers: { 'Authorization' => "Bearer #{token}" }, as: :json)
        
        expect(response).to have_http_status(:bad_request)
        expect(json_body).to include('error')
      end
    end
  end
end
