# frozen_string_literal: true
class Question < ApplicationRecord
  before_create :has_options

  validates :title, presence: true

  has_many :options
  has_and_belongs_to_many :exams

  private

    def has_options
      unless options.any?(&:correct?)
        errors.add(:options, 'must have one correct option')
        throw(:abort)
      end

      correct_options = options.select(&:correct)
      if correct_options.size > 1
        errors.add(:options, 'can only have one option with the attribute \'correct:true\'')
        throw(:abort)
      end

      if options.size < 2
        errors.add(:options, 'must be at least 2')
        throw(:abort)
      end

      if options.size > 5
        errors.add(:options, 'must be at most 5')
        throw(:abort)
      end
    end
end
