# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Revisions', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe 'GET /:id' do
    let!(:user) { create(:user) }
    let!(:revision) { create(:revision, :with_questions, id: 1) }

    it 'returns an revision successfully' do
      get '/api/revisions/1.json', headers: auth_headers

      expect(json_body).to include('exam_id')
      expect(json_body).to include('user_id')
      expect(json_body).to include('questions')
      expect(json_body['questions'].length).to eq(3)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /:id/evaluate' do
    let!(:user) { create(:user) }
    let!(:revision) { create(:revision, :with_questions, user:, id: 1) }

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
        post('/api/revisions/1/evaluate.json', params:, headers: auth_headers)

        expect(response).to have_http_status(:success)
        expect(json_body).to include('score')
      end

      it 'register a new answer' do
        expect do
          post('/api/revisions/1/evaluate.json', params:, headers: auth_headers)
        end.to change(Answer, :count).by(1)

        expect(response).to have_http_status(:success)
      end
    end

    describe 'when garden exists' do
      let!(:garden) { create(:garden, user_id: user.id) }
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

      it 'save new seeds to garden' do
        post('/api/revisions/1/evaluate.json', params:, headers: auth_headers_for(user))

        expect(response).to have_http_status(:success)
        expect(Garden.last.seeds).to be >= 1
        expect(Garden.last.nutrients).to be >= 1
      end
    end
  end
end
