# frozen_string_literal: true

module Questions
  class Bulk
    class << self
      def create(questions)
        Question.transaction do
          questions.each do |q|
            @question = Question.new(title: q[:title])
            @question.options.build(q[:options])
            @question.save!
          end
        end
      end
    end
  end
end
