# frozen_string_literal: true

module Users
  class Progress
    class << self
      def perform(answers)
        total_score = answers.sum(&:score)
        average_score = answers.empty? ? 0 : total_score.to_f / answers.length
        exam_ids = answers.map(&:exam_id)

        [average_score, exam_ids]
      end
    end
  end
end
