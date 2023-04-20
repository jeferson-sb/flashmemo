require 'rails_helper'

RSpec.describe "Questions", type: :request do
  describe "GET /index" do
    it 'returns a successful response' do
      get "/api/questions.json"

      expect(response).to be_successful
      expect(response.body).to eq([])
    end
  end
end
