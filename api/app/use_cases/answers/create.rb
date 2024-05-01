# frozen_string_literal: true

module Answers
  class Create
    class << self
      def perform(exam_id, user_id, score)
        answer = Answer.find_or_create_by(
          exam_id:,
          user_id:,
          score:
        )
        answer.attempt
        answer
      end
    end
  end
end
