# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  describe 'GET /categories' do
    before { create_list(:category, 5) }

    it 'returns all categories' do
      get '/api/categories.json'

      expect(response).to be_successful
    end
  end

  describe 'POST /categories' do
    let(:params) do
      {
        title: Faker::Lorem.word
      }
    end

    it 'creates a new unique category' do
      post('/api/categories.json', params:, headers: auth_headers)

      expect(response).to be_successful
    end
  end
end
