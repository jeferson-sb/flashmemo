require 'rails_helper'

RSpec.describe 'Questions', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  before { create(:question, :with_options) }

  describe 'GET /index' do
    it 'returns all questions' do
      get '/api/questions.json'

      expect(response).to be_successful
      expect(json_body.length).not_to eq(0)
    end
  end

  describe 'GET /:id' do
    it 'returns a question' do
      question = create(:question)
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
end
