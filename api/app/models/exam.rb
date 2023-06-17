class Exam < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :difficulty, presence: true
  validates :version, presence: true

  has_and_belongs_to_many :questions
  enum :difficulty, [:beginner, :intermediate, :advanced]
end
