# frozen_string_literal: true

module Exams
  class Evaluate
    class << self
      def perform(questions, total)
        points = 0.0

        questions.each do |question|
          option = Option.where(question_id: question[:id], correct: true).first
          points += 1.0 if option.id == question[:option_id]
        end

        ((points / total) * 100).round(2)
      end
    end
  end
end
