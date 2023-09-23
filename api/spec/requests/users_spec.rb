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
    let(:user) { create(:user) }

    describe 'when user have answers' do
      before { create(:answer) }

      it 'return average score' do
        get('/api/users/1/progress', params: { user_id: user.id })

        expect(response).to have_http_status(:success)
        expect(json_body).to include('average')
        expect(json_body).to include('exams')
      end
    end

    describe 'when time=monthly' do
      before do
        create_list(:answer, 2, user: user, created_at: Time.now)
        create(:answer, user: user, created_at: 1.month.ago)
      end

      it 'return average for the month' do
        get('/api/users/1/progress', params: { user_id: user.id, time: 'monthly' })

        expect(response).to have_http_status(:success)
        expect(json_body['exams'].length).to be(2)
      end
    end

    describe 'when time=yearly' do
      before do
        create_list(:answer, 3, user: user, created_at: Time.now)
        create(:answer, user: user, created_at: 1.year.ago)
      end

      it 'return average for the year' do
        get('/api/users/1/progress', params: { user_id: user.id, time: 'yearly' })

        expect(response).to have_http_status(:success)
        expect(json_body['exams'].length).to be(3)
      end
    end

    describe 'when time=semester' do
      before do
        create_list(:answer, 5, user: user, created_at: Time.now)
        create(:answer, user: user, created_at: 6.months.ago)
      end

      it 'return average for the last semester' do
        get('/api/users/1/progress', params: { user_id: user.id, time: 'semester' })

        expect(response).to have_http_status(:success)
        expect(json_body['exams'].length).to be(1)
      end
    end

    describe 'when no answers are found for the user' do
      before do
        create_list(:answer, 2, user: user, created_at: Time.now)
      end

      it 'return error' do
        get('/api/users/1/progress', params: { user_id: user.id, time: 'semester' })

        expect(response).to have_http_status(:not_found)
        expect(json_body).to include('error')
      end
    end
  end
end
