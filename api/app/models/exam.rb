# frozen_string_literal: true

class Exam < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :difficulty, presence: true
  validates :version, presence: true

  has_and_belongs_to_many :questions
  has_many :answer
  has_many :users, through: :answer
  enum :difficulty, %i[beginner intermediate advanced]

  def self.by_category(category_name)
    if category_name.present?
      category = Category.find_by(title: category_name.strip.downcase)
      where(category_id: category.id) 
    else
      Exam.all
    end
  end
end
