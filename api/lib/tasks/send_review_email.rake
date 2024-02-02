namespace :send_review_email do
  desc 'Send review email to answer revision'
  task :all => :environment do
    Revision.find_each do |rev|
      NotificationMailer.with(user: rev.user_id, url: "/api/revisions/#{rev.last.id}").review_email.deliver_now
    end
  end
end
