# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

allowed_origins = ENV.fetch('FRONTEND_ORIGINS', 'http://localhost:5173,http://localhost:4173').split(',')

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*allowed_origins)

    resource '/api/*',
             headers: :any,
             methods: %i[get post put patch delete options head],
             credentials: false
  end
end
