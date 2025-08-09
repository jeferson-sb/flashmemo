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
      get '/api/mindmaps.json'

      expect(response).to be_successful
    end
  end
end
