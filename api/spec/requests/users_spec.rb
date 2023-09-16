# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe 'POST /users' do
    let(:params) do
      {
        username: Faker::Name.name,
        email: Faker::Lorem.word
      }
    end

    it 'creates new user' do
      post('/api/users.json', params:)

      expect(response).to be_successful
    end
  end

  describe 'POST /users/:id/progress' do
    describe 'when user have answers' do
      before { create(:answer) }

      it 'return average score' do
        get('/api/users/1/progress')

        expect(response).to have_http_status(:success)
        expect(json_body).to include('average')
        expect(json_body).to include('exams')
      end
    end
  end
end
