# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :exam

  INTERVALS = {
    1 => 3.minutes,
    2 => 10.minutes,
    3 => 20.minutes
  }.freeze

  validates :user, presence: true
  validates :exam, presence: true
  validates :score, presence: true

  def attempt
    self.last_attempted_at = Time.now
    self.interval_level += 1 if score < 100 && interval_level < INTERVALS.keys.max
    save
  end

  def valid_interval?
    last_attempted_at + INTERVALS[self.interval_level] < Time.now
  end
end
