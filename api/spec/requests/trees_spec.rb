# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Trees', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe 'GET /' do
    let!(:trees) { create_list(:tree, 5) }

    it 'returns all trees' do
      get '/api/trees.json'

      expect(response).to be_successful
      expect(json_body.length).to eq(5)
    end
  end

  describe 'GET /:id' do
    let!(:tree) { create(:tree, id: 1) }

    it 'returns a tree successfully' do
      get '/api/trees/1.json'

      expect(response).to have_http_status(:success)
      expect(json_body).to include('name')
      expect(json_body).to include('owner_id')
    end
  end
end
