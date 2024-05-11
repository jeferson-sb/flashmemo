# frozen_string_literal: true

module Answers
  class Create
    class << self
      def perform(exam_id, user_id, score)
        answer = Answer.create(
          exam_id:,
          user_id:,
          score:,
        )
        answer
      end
    end
  end
end
