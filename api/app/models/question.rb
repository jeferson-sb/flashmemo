class Question < ApplicationRecord
  validates :title, presence: true

  has_many :options
  has_and_belongs_to_many :exams
end
