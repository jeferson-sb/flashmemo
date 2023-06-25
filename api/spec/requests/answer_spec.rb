require 'rails_helper'

RSpec.describe 'Answers', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe 'GET /:id' do
    it 'returns an answer to a question' do
      question = create(:question, :with_options)
      answer = create(:answer, question:)
      get '/api/answers/1.json'

      expect(response).to be_successful
      expect(json_body).to include('question_id')
    end
  end
end
