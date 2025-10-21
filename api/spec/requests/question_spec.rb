# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Questions', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  before { create(:question, :with_options, options_count: 3, id: 1) }

  describe 'GET /index' do
    it 'returns all questions' do
      get '/api/questions.json'

      expect(response).to be_successful
      expect(json_body.length).not_to eq(0)
    end
  end

  describe 'GET /:id' do
    it 'returns a question' do
      question = create(:question, :with_options, id: 2)
      get '/api/questions/1.json'

      expect(response).to be_successful
    end

    it 'returns options' do
      get '/api/questions/1.json'

      expect(response).to be_successful
      expect(json_body['options'].length).to eq(3)
    end
  end

  describe 'GET /random' do
    it 'returns a random question' do
      get '/api/questions/random.json'

      expect(response).to be_successful
      expect(response.parsed_body.keys).to contain_exactly 'id', 'title', 'options'
    end
  end

  describe 'DELETE /:id' do
    it 'delete specified question' do
      delete '/api/questions/1.json', headers: auth_headers

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'UPDATE /question' do
    let(:params) do
      {
        title: Faker::Lorem.question
      }
    end
    let(:file) do
      fixture_file_upload(Rails.root.join('spec', 'fixtures', 'rails.jpg'), 'image/jpeg')
    end
    let(:wrongfile) do
      fixture_file_upload(Rails.root.join('spec', 'fixtures', 'file.pdf'), 'application/pdf')
    end

    it 'updates title of the question' do
      put('/api/questions/1.json', params:, headers: auth_headers)

      expect(response).to be_successful
      expect(json_body).to include('title')
      expect(json_body['title']).to eq(params[:title])
    end

    it 'adds image to the question' do
      put('/api/questions/1.json', params: { image: file }, headers: auth_headers)

      expect(response).to have_http_status(:ok)
    end

    it 'adds wrong file to the question' do
      put('/api/questions/1.json', params: { image: wrongfile }, headers: auth_headers)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_body['error']).to include('Questions Invalid format. File extensions available: png, jpg, jpeg')
    end
  end

  describe 'POST /questions' do
    describe 'when options are not valid' do
      let(:params) do
        {
          title: Faker::Lorem.question,
          options: [
            {
              text: Faker::Lorem.sentence,
              correct: true
            }
          ]
        }
      end

      it 'returns an error message' do
        post('/api/questions.json', params:, headers: auth_headers)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body).to include('error')
      end
    end

    describe 'when options are valid' do
      let(:params) do
        {
          title: Faker::Lorem.question,
          options: [
            {
              text: Faker::Lorem.sentence,
              correct: true
            },
            {
              text: Faker::Lorem.sentence,
              correct: false
            }
          ]
        }
      end

      it 'create new question' do
        post('/api/questions.json', params:, headers: auth_headers)

        expect(response).to be_successful
      end
    end
  end

  describe 'POST /questions/bulk' do
    let(:valid_options) do
      [
        {
          text: Faker::Lorem.sentence,
          correct: true
        },
        {
          text: Faker::Lorem.sentence,
          correct: false
        }
      ]
    end
    let(:invalid_options) do
      [
        {
          text: Faker::Lorem.sentence,
          correct: true
        }
      ]
    end

    describe 'when options are valid' do
      let(:params) do
        { questions: [
          {
            title: Faker::Lorem.question,
            options: valid_options
          },
          {
            title: Faker::Lorem.question,
            options: valid_options
          }
        ] }
      end

      it 'creates all questions' do
        post('/api/questions/bulk.json', params:, headers: auth_headers)
        expect(response).to be_successful
      end
    end

    describe 'when invalid options' do
      let(:params) do
        { questions: [
          {
            title: 'What is DDD?',
            options: valid_options
          },
          {
            title: 'What defines a bounded context?',
            options: invalid_options
          }
        ] }
      end

      it 'returns an error message' do
        post('/api/questions/bulk.json', params:, headers: auth_headers)

        expect(response).to have_http_status(:bad_request)
        expect(json_body).to include('error')
      end
    end
  end
end
