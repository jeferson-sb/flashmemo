# frozen_string_literal: true

class SurpriseQuestionAnswer < ApplicationRecord
  belongs_to :question
  scope :per_user, ->(user_id) { where(user_id:) }
end
