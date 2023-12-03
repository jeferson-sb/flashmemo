# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Exams', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe 'GET /:id' do
    before { create(:exam, id: 1) }

    it 'returns an exam successfully' do
      get '/api/exams/1.json'

      expect(response).to have_http_status(:success)
      expect(json_body).to include('title')
    end
  end

  describe 'POST /:id/evaluate' do
    let!(:exam) { create(:exam, :with_questions, id: 1) }
    let(:question) { exam.questions.first }
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
        post('/api/exams/1/evaluate.json', params:)

        expect(response).to have_http_status(:success)
        expect(json_body).to include('score')
      end
    end
  end

  describe 'POST /exams' do
    let(:questions) { create_list(:question, 3, :with_options) }

    describe 'when title is unique' do
      let(:params) do
        {
          title: Faker::Lorem.word,
          difficulty: %i[beginner intermediate advanced].sample,
          version: 1,
          question_ids: questions.map(&:id)
        }
      end

      it 'creates a new exam' do
        post('/api/exams', params:)

        expect(response).to have_http_status(:success)
        expect(json_body).to include('message')
      end
    end
  end
end
