# frozen_string_literal: true

FactoryBot.define do
  factory :tree do
    name { Faker::Name.name }
    phase { :seed }
    health { 100 }

    association :garden

    trait :dry do
      after(:build) do |tree|
        tree.health = 5
      end
    end
  end
end
