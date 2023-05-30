require 'rails_helper'

RSpec.describe "Exams", type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe "GET /:id" do
    before { create(:exam) }

    it "returns an exam successfully" do
      get "/api/exams/1.json"
      
      expect(response).to have_http_status(:success)
      expect(json_body).to include('title')
    end
  end

  describe "POST /:id/evaluate" do
    before { create(:exam, :with_questions) }

    let(:params) do
      {
        id: 1,
        option_id: 2 
      }
    end

    it "return score for an exam" do
      post "/api/exams/1/evaluate.json", params: params
      
      expect(response).to have_http_status(:success)
    end
  end
end
