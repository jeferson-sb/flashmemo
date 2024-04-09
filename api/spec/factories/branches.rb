# frozen_string_literal: true

FactoryBot.define do
  factory :branch do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
    health { 100 }

    association :tree
  end
end
