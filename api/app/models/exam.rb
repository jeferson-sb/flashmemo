# frozen_string_literal: true

class Exam < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :difficulty, presence: true
  validates :version, presence: true

  has_and_belongs_to_many :questions
  has_many :answer
  has_many :users, through: :answer
  enum :difficulty, %i[beginner intermediate advanced]
end
