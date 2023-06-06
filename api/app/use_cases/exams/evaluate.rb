# frozen_string_literal: true

module Exams
  class Evaluate
    def perform(questions, total)
      points = 0.0
      error = nil

      questions.each do |question|
        option = Option.where(question_id: question[:id], correct: true).first

        if option.nil?
          error = "No valid options found for question with id: #{question[:id]}"
        else
          points += 1.0 if option.id == question[:option_id]
        end
      end

      score = ((points / total) * 100).round(2)

      [score, error]
    end
  end
end
