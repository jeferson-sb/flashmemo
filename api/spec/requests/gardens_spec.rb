# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Gardens', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }

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
    it 'creates a new garden successfully' do
      post '/api/gardens.json', headers: { 'Authorization' => "Bearer #{token}" }

      expect(response).to have_http_status(:success)
      expect(json_body).to include('message')
    end
  end

  describe 'POST /:id/plant' do
    let(:params) do
      {
        name: Faker::Name.name
      }
    end

    describe 'when seeds <= 0' do
      before { create(:garden, id: 1) }

      it 'returns error message' do
        post '/api/gardens/1/plant.json', params:, headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:bad_request)
        expect(json_body).to include('error')
      end
    end

    describe 'when seeds is positive' do
      before { create(:garden, id: 1, seeds: 2) }

      it 'creates a new tree successfully' do
        post '/api/gardens/1/plant.json', params:, headers: { 'Authorization' => "Bearer #{token}" }
  
        expect(response).to have_http_status(:success)
        expect(json_body).to include('message')
      end
    end
  end

  describe 'POST /:id/nurture' do

    describe 'when nutrients <= 0' do
      before { 
        create(:garden, id: 1) 
        create(:tree, id: 1)
      }

      let(:params) do
        {
          tree_id: 1,
          nutrients: 0
        }
      end
    
      it 'returns error message' do
        post '/api/gardens/1/nurture.json', params:, headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:bad_request)
        expect(json_body).to include('error')
      end
    end

    describe 'when nutrients is positive' do
      let!(:garden) { create(:garden, id: 1, nutrients: 10) }
      
      describe 'when tree health is already 100' do
        let!(:tree) { create(:tree, health: 100) }
        let(:params) do
          {
            tree_id: tree.id,
            nutrients: 5
          }
        end
    
        it 'returns error message' do
          post '/api/gardens/1/nurture.json', params:, headers: { 'Authorization' => "Bearer #{token}" }
    
          expect(response).to have_http_status(:bad_request)
          expect(json_body).to include('error')
        end
      end

      describe 'when nutrients are over tree health' do
        let!(:tree) { create(:tree, health: 90) }
        let(:params) do
          {
            tree_id: tree.id,
            nutrients: 12
          }
        end
    
        it 'returns error message' do
          post '/api/gardens/1/nurture.json', params:, headers: { 'Authorization' => "Bearer #{token}" }
    
          expect(response).to have_http_status(:bad_request)
          expect(json_body).to include('error')
        end
      end

      describe 'when enough nutrients' do
        let!(:tree) { create(:tree, health: 50) }
        let(:params) do
          {
            tree_id: tree.id,
            nutrients: 5
          }
        end
    
        it 'feeds a tree' do
          post '/api/gardens/1/nurture.json', params:, headers: { 'Authorization' => "Bearer #{token}" }
    
          expect(response).to have_http_status(:success)
          expect(json_body).to include('message')
        end
      end
    end
  end
end
