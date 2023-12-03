# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Revisions', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe 'GET /:id' do
    let!(:user) { create(:user) }
    let!(:revision) { create(:revision, id: 1) }
    let!(:token) { JsonWebToken.encode(user_id: user.id) }

    it 'returns an revision successfully' do
      get revision_path('/api/revisions/1', headers: { 'Authorization' => "Bearer #{token}" })

      expect(response).to have_http_status(:success)
    end
  end
end
