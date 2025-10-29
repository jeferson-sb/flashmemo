# frozen_string_literal: true

FactoryBot.define do
  factory :mind_map do
    name { Faker::Name.name }

    association :user
  end
end
