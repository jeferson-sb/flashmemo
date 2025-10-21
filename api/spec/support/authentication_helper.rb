# frozen_string_literal: true

module AuthenticationTestHelper
  def auth_headers_for(user)
    session = create(:session, user: user)
    { 'Authorization' => "Bearer #{session.token}" }
  end

  def auth_headers
    user = create(:user)
    auth_headers_for(user)
  end
end

RSpec.configure do |config|
  config.include AuthenticationTestHelper, type: :request
end
