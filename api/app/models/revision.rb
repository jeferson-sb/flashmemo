# frozen_string_literal: true

class Revision < ApplicationRecord
  belongs_to :exam
  belongs_to :user

  has_many :questions

  validates :user, presence: true
  validates :exam, presence: true
end
