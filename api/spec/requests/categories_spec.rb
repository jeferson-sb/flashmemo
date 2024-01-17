# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  describe 'POST /categories' do
    let(:params) do
      {
        title: Faker::Lorem.word
      }
    end

    it 'creates a new unique category' do
      post('/api/categories.json', params:)

      expect(response).to be_successful
    end
  end
end
