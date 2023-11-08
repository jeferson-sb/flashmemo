# frozen_string_literal: true

class Question < ApplicationRecord
  validate :validate_options

  validates :title, presence: true

  has_many :options, dependent: :destroy
  has_and_belongs_to_many :exams
  has_one_attached :image

  validate :validate_image

  private

  def validate_options
    errors.add(:options, 'At least one option should be present') if options.empty?
    unless options.any?(&:correct?)
      errors.add(:options,
                 'can only have one option with the attribute \'correct:true\'')
    end
    errors.add(:options, 'must be at least 2') if options.size < 2
    errors.add(:options, 'must be at most 5') if options.size > 5
  end

  def validate_image
    return unless image.attached?

    if image.blob.byte_size > 1.megabyte
      image.purge
      errors.add(:questions, "Image size should be less than 1mb")
    elsif !image.blob.content_type.starts_with?('image/')
      image.purge
      errors.add(:questions, "Invalid format. File extensions available: png, jpg, jpeg")
    end
  end
end
