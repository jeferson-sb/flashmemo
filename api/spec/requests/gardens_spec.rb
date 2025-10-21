# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Gardens', type: :request do
  let(:json_body) do
    JSON.parse(response.body)
  end

  describe 'GET /' do
    before { create_list(:garden, 5) }

    it 'returns all gardens' do
      get '/api/gardens.json'

      expect(response).to be_successful
      expect(json_body.length).to eq(5)
    end
  end

  describe 'GET /:id' do
    before { create(:garden, id: 1) }

    it 'returns a garden successfully' do
      get '/api/gardens/1.json'

      expect(response).to have_http_status(:success)
      expect(json_body).to include('name')
      expect(json_body).to include('trees')
    end
  end

  describe 'POST /' do
    it 'creates a new garden successfully' do
      post '/api/gardens.json', headers: auth_headers

      expect(response).to have_http_status(:success)
      expect(json_body).to include('message')
    end
  end

  describe 'POST /:id/plant' do
    let(:params) do
      {
        name: Faker::Name.name
      }
    end

    describe 'when seeds <= 0' do
      before { create(:garden, id: 1) }

      it 'returns error message' do
        post '/api/gardens/1/plant.json', params:, headers: auth_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body).to include('error')
      end
    end

    describe 'when seeds is positive' do
      before { create(:garden, id: 1, seeds: 2) }

      it 'creates a new tree successfully' do
        post '/api/gardens/1/plant.json', params:, headers: auth_headers

        expect(response).to have_http_status(:success)
        expect(json_body).to include('message')
      end
    end
  end

  describe 'POST /:id/nurture' do
    describe 'when nutrients <= 0' do
      before do
        create(:garden, id: 1)
        create(:tree, id: 1)
      end

      let(:params) do
        {
          tree_id: 1,
          nutrients: 0
        }
      end

      it 'returns error message' do
        post '/api/gardens/1/nurture.json', params:, headers: auth_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body).to include('error')
      end
    end

    describe 'when nutrients is positive' do
      let!(:garden) { create(:garden, id: 1, nutrients: 10) }

      describe 'when tree health is already 100' do
        let!(:tree) { create(:tree, health: 100) }
        let(:params) do
          {
            tree_id: tree.id,
            nutrients: 5
          }
        end

        it 'returns error message' do
          post '/api/gardens/1/nurture.json', params:, headers: auth_headers

          expect(response).to have_http_status(:bad_request)
          expect(json_body).to include('error')
        end
      end

      describe 'when nutrients are over tree health' do
        let!(:tree) { create(:tree, health: 90) }
        let(:params) do
          {
            tree_id: tree.id,
            nutrients: 12
          }
        end

        it 'returns error message' do
          post '/api/gardens/1/nurture.json', params:, headers: auth_headers

          expect(response).to have_http_status(:bad_request)
          expect(json_body).to include('error')
        end
      end

      describe 'when enough nutrients' do
        let!(:tree) { create(:tree, health: 50) }
        let(:params) do
          {
            tree_id: tree.id,
            nutrients: 5
          }
        end

        it 'feeds a tree' do
          post '/api/gardens/1/nurture.json', params:, headers: auth_headers

          expect(response).to have_http_status(:success)
          expect(json_body).to include('message')
        end
      end
    end
  end

  describe 'GET /:id/journal' do
    describe 'when garden avaliable' do
      let!(:garden) { create(:garden, :with_trees, seeds: 2) }
      let(:tree) { create(:tree) }

      it 'returns default garden journal summary' do
        get "/api/gardens/#{garden.id}/journal.json", headers: auth_headers

        expect(response).to have_http_status(:success)
        expect(json_body).to include('today')
        expect(json_body['message']).to include('Your daily journal')
        expect(json_body['trees_count']).to eq(2)
        expect(json_body['stock']['seeds']).to eq(2)
        expect(json_body['stock']['nutrients']).to eq(0)
      end
    end

    describe 'when answers are available' do
      let!(:user) { create(:user) }
      let!(:garden) { create(:garden, user_id: user.id) }
      let!(:answers) { create_list(:answer, 5, user:, created_at: Time.now) }

      it 'returns journal with monthly question' do
        get "/api/gardens/#{garden.id}/journal.json", headers: auth_headers_for(user)

        expect(response).to have_http_status(:success)
        expect(json_body).to include('monthly_progress_score')
        expect(json_body['monthly_progress_score']).to be > 0
      end
    end
  end

  describe 'POST /:id/journal/surprise_question' do
    let!(:user) { create(:user) }
    let!(:garden) { create(:garden, :with_trees, user_id: user.id, seeds: 2) }
    let!(:surprise_question) { create(:question, :with_options) }

    before do
      surprise_question.mark_as_surprise_question
    end

    describe 'when wrong answer' do
      let(:params) do
        { answer: 1 }
      end

      it 'return error message' do
        post "/api/gardens/#{garden.id}/journal/surprise_question", params:,
                                                                    headers: auth_headers_for(user)

        expect(response).to have_http_status(:success)
        expect(json_body['result']).to eq('Oops, try again!')
      end
    end

    describe 'when correct answer' do
      let(:params) do
        { answer: surprise_question.options.first.id }
      end

      it 'return with bonus earned' do
        post "/api/gardens/#{garden.id}/journal/surprise_question", params:,
                                                                    headers: auth_headers_for(user)

        expect(response).to have_http_status(:success)
        expect(json_body['result']).to include('Great! You just won')
      end
    end

    describe 'when max attempts reached' do
      before do
        create_list(:surprise_question_answer, 3, user_id: user.id, question_id: surprise_question.id)
      end

      let(:params) do
        { answer: surprise_question.options.first.id }
      end

      it 'return error message' do
        post "/api/gardens/#{garden.id}/journal/surprise_question", params:,
                                                                    headers: auth_headers_for(user)

        expect(response).to have_http_status(:success)
        expect(json_body['error']).to eq('Reached limit attempts for this user!')
      end
    end
  end
end
