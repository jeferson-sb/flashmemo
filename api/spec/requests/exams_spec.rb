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
end
