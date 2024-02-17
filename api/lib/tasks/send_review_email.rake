namespace :send_review_email do
  desc 'Send review email to answer revision'
  task all: :environment do
    Revision.find_each(batch_size: 100) do |rev|
      answer = rev.exam.answer.last
      is_enough_questions = rev.questions.length > 1
      if is_enough_questions && answer.valid_interval?
        puts "[LOG] #{Time.now}: sending e-mail revision #{rev.id}"
        NotificationMailer.with(user: rev.user_id, url: "/api/revisions/#{rev.last.id}").review_email.deliver_now
      end
    end
  end
end
