# frozen_string_literal: true

class SendReviewEmailJob < ApplicationJob
  queue_as :background

  # Trigger a notification based on reinforcing learning,
  # so need to trigger once for the following intervals:
  #
  # 1st time: 3 days
  # 2nd time: 1 week
  # 3rd time: 1 month
  #
  # The interval will then be incremented once the user accesses the link sent, and answer the revision
  def perform
    Revision.find_each(batch_size: 100) do |rev|
      last_attempt = rev.exam.answer.where(user_id: rev.user_id).last
      has_enough_questions = rev.questions.length > 1
      is_valid_interval = last_attempt.score < 100 && rev.valid_interval?(last_attempt.created_at)

      if has_enough_questions && is_valid_interval
        Rails.logger.info "[LOG] #{Time.now}: sending e-mail revision #{rev.id}"
        NotificationMailer.with(user: rev.user_id, url: "/api/revisions/#{rev.id}").review_email.deliver_now
      end
    end
  end
end
