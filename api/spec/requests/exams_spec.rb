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

  describe 'GET /' do
    before { create(:exam) }

    it 'returns all exams' do
      get '/api/exams.json'

      expect(response).to be_successful
      expect(json_body.length).not_to eq(0)
    end
  end

  describe 'POST /:id/evaluate' do
    let!(:user) { create(:user) }
    let!(:exam) { create(:exam, :with_questions, id: 1) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    let(:question) { exam.questions.first }
    let(:option) { question.options.first }
    let(:miss_option) { question.options.last }

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
        post('/api/exams/1/evaluate.json', params:, headers: { 'Authorization' => "Bearer #{token}" })

        expect(response).to have_http_status(:success)
        expect(json_body).to include('score')
      end

      it 'register a new answer' do
        expect {
          post('/api/exams/1/evaluate.json', params:, headers: { 'Authorization' => "Bearer #{token}" })
        }.to change(Answer, :count).by(1)

        expect(response).to have_http_status(:success)
      end

    end
    
    describe 'when missed a question' do
      let(:params) do
        {
          questions: [
            {
              id: question.id,
              option_id: miss_option.id
            }
          ]
        }
      end
  
      it 'register a new revision' do
        expect {
          post('/api/exams/1/evaluate.json', params:, headers: { 'Authorization' => "Bearer #{token}" })
        }.to change(Revision, :count).by(1)
  
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
        post('/api/exams/1/evaluate.json', params:, headers: { 'Authorization' => "Bearer #{token}" })
        
        expect(response).to have_http_status(:success)
        expect(Garden.last.seeds).to eq(1)
        expect(Garden.last.nutrients).to eq(0)
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

  describe 'GET /exams/:id/duos' do
    let!(:exam) { create(:exam, :with_duos, id: 1) }

    describe 'when question.has_duo' do
      it 'return duos list randomly' do
        get '/api/exams/1/duos'

        expect(response).to have_http_status(:success)

        expect(json_body).to include('title')
        expect(json_body['duos'][0].length).not_to eq(0)
        expect(json_body['duos'][1].length).not_to eq(0)
      end
    end
  end

  describe 'POST /exams/:id/duos/evaluate' do
    let!(:exam) { create(:exam, :with_duos, id: 1) }

    describe 'when does NOT match duos' do
      let(:params) do
        {
          duos: exam.questions.map { |q| [q.id, q.options[1].id] }
        }
      end

      it 'return failure message' do
        post '/api/exams/1/duos/evaluate', params:, as: :json

        expect(response).to have_http_status(:bad_request)
        expect(json_body['message']).to eq('Oops, try again!')
      end
    end

    describe 'when DOES match duos' do
      let(:params) do
        {
          duos: exam.questions.map { |q| [q.id, q.options[0].id] }
        }
      end

      it 'return success message' do
        post '/api/exams/1/duos/evaluate', params:, as: :json

        expect(response).to have_http_status(:success)
        expect(json_body['message']).to eq('Well done!')
      end
    end
  end
end
