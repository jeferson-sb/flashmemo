# frozen_string_literal: true

class Revision < ApplicationRecord
  belongs_to :exam
  belongs_to :user

  has_many :questions

  validates :user, presence: true
  validates :exam, presence: true

  INTERVALS = {
    1 => 3.days,
    2 => 1.week,
    3 => 1.month
  }.freeze

  def increment_interval
    self.interval_level += 1 if interval_level < INTERVALS.keys.max
  end

  def valid_interval?(date)
    self.interval_level == 0 || date + INTERVALS[self.interval_level] < Time.now
  end
end
