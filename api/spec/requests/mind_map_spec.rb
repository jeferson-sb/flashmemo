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

  describe 'GET /:mindmap_id/graph' do
    let(:mind_map) { create(:mind_map) }

    after { CategoryNode.where(mindmap_id: mind_map.id).destroy_all }

    it 'is public, like index and show' do
      get "/api/mindmaps/#{mind_map.id}/graph.json"

      expect(response).to be_successful
    end

    it 'returns an empty graph for a mind map with no nodes yet' do
      get "/api/mindmaps/#{mind_map.id}/graph.json", headers: auth_headers

      expect(json_body).to eq('nodes' => [], 'edges' => [])
    end

    it 'renders the nodes and edges stored in Neo4j' do
      node = CategoryNode.create!(name: 'Ruby', category_id: 1, mindmap_id: mind_map.id)

      get "/api/mindmaps/#{mind_map.id}/graph.json", headers: auth_headers

      expect(json_body['nodes']).to eq([{ 'id' => node.id, 'label' => 'Ruby', 'type' => 'category' }])
    end

    it '404s for a mind map that does not exist' do
      get '/api/mindmaps/0/graph.json', headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
