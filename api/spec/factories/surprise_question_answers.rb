# frozen_string_literal: true

FactoryBot.define do
  factory :surprise_question_answer do
    winner { false }

    association :user
    association :question
  end
end
