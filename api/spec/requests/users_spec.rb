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
        email: Faker::Lorem.word,
        password: Faker::Lorem.characters(number: 10)
      }
    end

    it 'creates new user' do
      post('/api/users.json', params:)

      expect(response).to be_successful
    end
  end

  describe 'POST /users/:id/progress' do
    let(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    describe 'when user have answers' do
      before { create(:answer) }

      it 'return average score' do
        get('/api/users/1/progress', params: { user_id: user.id }, headers: { 'Authorization' => "Bearer #{token}" })

        expect(response).to have_http_status(:success)
        expect(json_body).to include('average')
        expect(json_body).to include('exams')
      end
    end

    describe 'when time=monthly' do
      let!(:answers) { create_list(:answer, 2, user:, created_at: Time.now) }
      let!(:answer) { create(:answer, user:, created_at: 1.month.ago) }

      it 'return average for the month' do
        get('/api/users/1/progress', params: { user_id: user.id, time: 'monthly' },
                                     headers: { 'Authorization' => "Bearer #{token}" })

        expect(response).to have_http_status(:success)
        expect(json_body['exams'].length).to be(2)
      end
    end

    describe 'when time=yearly' do
      let!(:answers) { create_list(:answer, 3, user:, created_at: Time.now) }
      let!(:answer) { create(:answer, user:, created_at: 1.year.ago) }

      it 'return average for the year' do
        get('/api/users/1/progress', params: { user_id: user.id, time: 'yearly' },
                                     headers: { 'Authorization' => "Bearer #{token}" })

        expect(response).to have_http_status(:success)
        expect(json_body['exams'].length).to be(3)
      end
    end

    describe 'when time=semester' do
      let!(:answers) { create_list(:answer, 5, user:, created_at: Time.now) }
      let!(:answer) { create(:answer, user:, created_at: 6.months.ago) }

      it 'return average for the last semester' do
        get('/api/users/1/progress', params: { user_id: user.id, time: 'semester' },
                                     headers: { 'Authorization' => "Bearer #{token}" })

        expect(response).to have_http_status(:success)
        expect(json_body['exams'].length).to be(1)
      end
    end

    describe 'when no answers are found for the user' do
      let!(:answers) { create_list(:answer, 2, user:, created_at: Time.now) }

      it 'return error' do
        get('/api/users/1/progress', params: { user_id: user.id, time: 'semester' },
                                     headers: { 'Authorization' => "Bearer #{token}" })

        expect(response).to have_http_status(:not_found)
        expect(json_body).to include('error')
      end
    end
  end
end
