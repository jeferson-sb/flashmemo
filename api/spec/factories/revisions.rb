# frozen_string_literal: true

FactoryBot.define do
  factory :revision do
    association :user
    association :exam

    transient do
      questions_count { 3 }
    end

    trait :with_questions do
      after(:create) do |revision, evaluator|
        revision.questions = create_list(:question, evaluator.questions_count, :with_options)
      end
    end
  end
end
