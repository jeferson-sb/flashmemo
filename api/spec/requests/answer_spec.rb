# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Answers', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe 'GET /:id' do
    before { create(:answer) }

    it 'returns a user-exam answer' do
      get '/api/answers/1.json'

      expect(response).to be_successful
      expect(json_body).to include('score')
    end
  end
end
