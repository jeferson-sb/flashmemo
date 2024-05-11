# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :exam

  validates :user, presence: true
  validates :exam, presence: true
  validates :score, presence: true

  def last_attempted_over_a_day?
    Time.now - created_at > 1.day
  end
end
