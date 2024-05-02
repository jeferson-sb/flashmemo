# frozen_string_literal: true

module Revisions
  class Create
    class << self
      def perform(exam_id, user_id, questions_answered_incorrectly)
        return unless questions_answered_incorrectly.length > 0

        revision = Revision.find_or_create_by(exam_id:, user_id:)
        revision.question_ids = questions_answered_incorrectly
        revision.save!
      end
    end
  end
end
