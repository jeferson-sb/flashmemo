namespace :send_review_email do
  desc 'Send review email to answer revision'
  task :all => :environment do
    Revision.find_each do |rev|
      last_ans = rev.exam.answer
      if rev.questions.length > 1 && !last_ans
        puts "[LOG] #{Time.now}: sending e-mail revision #{rev.id}"

        NotificationMailer.with(user: rev.user_id, url: "/api/revisions/#{rev.last.id}").review_email.deliver_now
      end
    end
  end
end
