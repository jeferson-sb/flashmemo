# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendReviewEmailJob, type: :job do
  describe '#perform' do
    let!(:rev_with_questions) { create(:revision, :with_questions, id: 2) }
    let!(:answer) do
      create(:answer,
             user_id: rev_with_questions.user.id,
             exam_id: rev_with_questions.exam.id,
             score: 50,
             created_at: 3.days.ago)
    end

    it 'send review email when having enough questions and answer in the valid interval' do
      allow(NotificationMailer).to receive_message_chain(:with, :review_email, :deliver_now)

      described_class.perform_now

      expect(NotificationMailer).to have_received(:with).with(hash_including(user: rev_with_questions.user.id,
                                                                             url: "/api/revisions/#{rev_with_questions.id}"))
    end
  end
end
