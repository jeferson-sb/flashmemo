# frozen_string_literal: true

module Answers
  class Create
    class << self
      def perform(exam_id, user_id, score)
        Answer.create(
          exam_id:,
          user_id:,
          score:
        )
      end
    end
  end
end
