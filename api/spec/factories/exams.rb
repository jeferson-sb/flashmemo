# frozen_string_literal: true

FactoryBot.define do
  factory :exam do
    title { Faker::Lorem.word }
    difficulty { %i[beginner intermediate advanced].sample }
    version { 1 }

    transient do
      question_count { 4 }
      options_count { 5 }
    end

    trait :with_questions do
      after(:create) do |exam, evaluator|
        exam.questions = create_list(:question, evaluator.question_count, :with_options)
      end
    end

    trait :with_duos do
      after(:create) do |exam, evaluator|
        exam.questions = create_list(:question, evaluator.question_count, :duos)
      end
    end
  end
end
