require 'rails_helper'

RSpec.describe 'Questions', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  before { create(:question, :with_options, options_count: 3) }

  describe 'GET /index' do
    it 'returns all questions' do
      get '/api/questions.json'

      expect(response).to be_successful
      expect(json_body.length).not_to eq(0)
    end
  end

  describe 'GET /:id' do
    it 'returns a question' do
      question = create(:question, :with_options)
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

  describe 'UPDATE /question' do
    let(:params) do
      { 
        title: Faker::Lorem.question,
      }
    end

    it 'updates title of the question' do
      put('/api/questions/1.json', params:)

      expect(response).to be_successful
      expect(json_body).to include("title")
      expect(json_body['title']).to eq(params[:title])
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
            },
          ]
        }
      end

      it 'returns an error message' do
        post('/api/questions.json', params:)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body).to include("error")
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
        post('/api/questions.json', params:)

        expect(response).to be_successful
      end
    end
  end
end
