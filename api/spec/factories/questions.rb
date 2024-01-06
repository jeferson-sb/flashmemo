# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { Faker::Lorem.question }

    transient do
      options_count { 2 }
    end

    trait :with_options do
      after(:build) do |question, evaluator|
        question.options = build_list(:option, evaluator.options_count, question:)
        question.options.first.update(correct: true)
      end
    end

    trait :duos do
      after(:build) do |question, evaluator|
        question.has_duo = true
        question.options = build_list(:option, evaluator.options_count, question:)
        question.options.first.update(correct: true)
      end
    end
  end
end
