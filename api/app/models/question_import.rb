# frozen_string_literal: true

class QuestionImport < ApplicationRecord
  MAX_FILE_SIZE = 5.megabytes
  ACCEPTED_EXTENSION = '.xlsx'

  belongs_to :exam
  belongs_to :user

  has_one_attached :file

  enum :status, %i[pending processing completed failed]

  scope :for_user, ->(user_id) { where(user_id:) }

  def finished?
    completed? || failed?
  end
end
