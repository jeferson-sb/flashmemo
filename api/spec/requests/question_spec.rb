require 'rails_helper'

RSpec.describe "Questions", type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  def create_question_with_options(count: 3)
    create(:question) do |question|
      create_list(:option, count, question: question)
    end
  end

  describe "GET /index" do
    it 'returns all questions' do
      get "/api/questions.json"

      expect(response).to be_successful
      expect(json_body).to eq([])
    end
  end

  describe "GET /:id" do
    it 'returns a question' do
      question = create(:question)
      get "/api/questions/1.json"

      expect(response).to be_successful
    end

    it 'returns options' do
      create_question_with_options
      get "/api/questions/1.json"

      expect(response).to be_successful
      expect(json_body['options'].length).to eq(3)
    end
  end
end
