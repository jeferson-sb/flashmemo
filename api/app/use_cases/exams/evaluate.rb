# frozen_string_literal: true

module Exams
  class Evaluate
    class << self
      def perform(questions, total)
        points = 0.0
        questions_answered_incorrectly = []

        questions.each do |question|
          option = Option.where(question_id: question[:id], correct: true).first

          if option.id == question[:option_id]
            points += 1.0
          else
            questions_answered_incorrectly << question[:id]
          end
        end

        return ((points / total) * 100).round(2), questions_answered_incorrectly
      end
    end
  end
end
