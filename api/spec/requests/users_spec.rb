require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users" do
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
end
