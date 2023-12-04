# frozen_string_literal: true

FactoryBot.define do
  factory :revision do
    association :user
    association :exam

    trait :with_questions do
      after(:create) do |revision|
        revision.questions = create_list(:question, 3, :with_options)
      end
    end
  end
end
