# frozen_string_literal: true

class Revision < ApplicationRecord
  after_create :schedule_review
  belongs_to :exam
  belongs_to :user

  has_many :questions

  validates :user, presence: true
  validates :exam, presence: true

  def schedule_review
    NotificationMailer
      .with(user: User.find(user_id), url: "/api/revisions/#{id}")
      .review_email
      .deliver_later(wait_until: 3.day.from_now)
  end
end
