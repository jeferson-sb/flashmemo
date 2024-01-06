# frozen_string_literal: true

module Questions
  class Duos
    class << self
      def duos(exam_questions)
        options = []
        questions = []

        exam_questions.each do |question|
          next unless question.has_duo

          option = question.options.find(&:correct)
          questions << { title: question.title, id: question.id }
          options << { text: option.text, id: option.id }
        end

        duos = [questions.shuffle, options.shuffle]
      end

      def evaluate(duos)
        duos.all? do |duo|
          question_id, option_id = duo
          option = Option.where(question_id:, id: option_id).first
          option&.correct
        end
      end
    end
  end
end
