# frozen_string_literal: true

module Exams
  class Evaluate
    class << self
      def perform(questions, total)
        points = 0.0
        question_ids = []

        questions.each do |question|
          option = Option.where(question_id: question[:id], correct: true).first

          if option.id == question[:option_id]
            points += 1.0
          else
            question_ids << question[:id]
          end
        end

        return ((points / total) * 100).round(2), question_ids
      end
    end
  end
end
