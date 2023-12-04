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
      get '/api/revisions/1.json', headers: { 'Authorization' => "Bearer #{token}" }
  
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /:id/evaluate' do
    let!(:user) { create(:user) }
    let!(:revision) { create(:revision, :with_questions, id: 1) }
    let!(:token) { JsonWebToken.encode(user_id: user.id) }

    let(:question) { revision.questions.first }
    let(:option) { question.options.first }

    describe 'when question exists' do
      let(:params) do
        {
          questions: [
            {
              id: question.id,
              option_id: option.id
            }
          ]
        }
      end

      it 'return score for an exam' do
        post('/api/revisions/1/evaluate.json', params:, headers: { 'Authorization' => "Bearer #{token}" })

        expect(response).to have_http_status(:success)
        expect(json_body).to include('score')
      end
    end
  end
end
