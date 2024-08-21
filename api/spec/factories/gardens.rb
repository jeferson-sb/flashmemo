# frozen_string_literal: true

FactoryBot.define do
  factory :garden do
    name { Faker::Name.name }
    seeds { 0 }
    nutrients { 0 }

    association :user

    transient do
      trees_count { 2 }
    end

    trait :with_trees do
      after(:create) do |garden, evaluator|
        garden.trees = create_list(:tree, evaluator.trees_count)
      end
    end
  end
end
