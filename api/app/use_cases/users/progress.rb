# frozen_string_literal: true

module Users
  class Progress
    class << self
      def perform(answers)
        exams = []
        total = 0

        answers.each do |answer|
          total += answer.score
          exams << answer.exam_id
        end

        average = (total / answers.length)

        [average, exams]
      end
    end
  end
end
