# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    username { Faker::Name.name }
    email { Faker::Lorem.word }
    password { Faker::Lorem.characters(number: 10) }
  end
end
