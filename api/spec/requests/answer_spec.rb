# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Answers', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe 'GET /:id' do
    before { create(:answer) }

    it 'returns a user-exam answer' do
      get '/api/answers/1.json'

      expect(response).to be_successful
      expect(json_body).to include('score')
    end
  end

  describe 'POST /answers' do
    let!(:exam) { create(:exam, :with_questions) }
    let!(:user) { create(:user) }

    let(:params) do
      {
        score: 50, 
        user_id: user.id,
        exam_id: exam.id
      }
    end

    it 'creates a new answers' do
      post('/api/answers.json', params:)

      expect(response).to be_successful
    end

    describe 'when no user and exam given' do
      let(:params) do
        {
          score: 50
        }
      end

      it 'return error message' do
        post('/api/answers.json', params:)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body).to include('error')
      end
    end
  end
end
