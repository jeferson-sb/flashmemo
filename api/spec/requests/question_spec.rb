require 'rails_helper'

RSpec.describe "Questions", type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe "GET /index" do
    it 'returns all questions' do
      get "/api/questions.json"

      expect(response).to be_successful
      expect(json_body).to eq([])
    end
  end

  describe "GET /:id" do
    before { create(:question, :with_options) }

    it 'returns a question' do
      question = create(:question)
      get "/api/questions/1.json"

      expect(response).to be_successful
    end

    it 'returns options' do
      get "/api/questions/1.json"

      expect(response).to be_successful
      expect(json_body['options'].length).to eq(3)
    end
  end
end
