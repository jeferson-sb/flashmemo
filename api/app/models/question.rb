class Question < ApplicationRecord
  validates :title, presence: true

  has_many :options
  has_many :exams
end
