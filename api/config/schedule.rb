# frozen_string_literal: true

env :PATH, ENV['PATH']
set :environment, :development
set :output, "#{path}/log/cron.log"

every :day do
  rake 'send_review_email:all'
end
