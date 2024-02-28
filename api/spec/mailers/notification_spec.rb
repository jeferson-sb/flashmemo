# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe 'review' do
    let(:user) { create(:user) }
    let(:mail) { NotificationMailer.with(user:, url: '/api/revisions/1').review_email }

    it 'renders the subject' do
      expect(mail.subject).to eq('Hey, Review time!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@flashmemo.com'])
    end
  end
end
