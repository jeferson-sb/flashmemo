# frozen_string_literal: true

require 'rails_helper'

describe 'send_review_email:all' do
  before :all do
    Api::Application.load_tasks
    Rake::Task.define_task(:environment)
  end

  describe 'when having enough questions and answer is in valid interval' do
    let!(:rev_with_questions) { create(:revision, :with_questions, id: 2) }
    let!(:answer) do
      create(:answer,
             user_id: rev_with_questions.user.id,
             exam_id: rev_with_questions.exam.id,
             score: 50,
             created_at: 3.days.ago
      )
    end

    it 'sends review email for revision' do
      allow(NotificationMailer).to receive_message_chain(:with, :review_email, :deliver_now)
      Rake::Task['send_review_email:all'].invoke
      expect(NotificationMailer).to have_received(:with).with(hash_including(user: rev_with_questions.user.id,
                                                                             url: "/api/revisions/#{rev_with_questions.id}"))
    end
  end
end
