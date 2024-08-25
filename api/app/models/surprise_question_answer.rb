# frozen_string_literal: true

class SurpriseQuestionAnswer < ApplicationRecord
  belongs_to :question
  scope :per_user, ->(user_id, question_id) { where(user_id:, question_id:) }

  MAX_ATTEMPTS = 3
end
