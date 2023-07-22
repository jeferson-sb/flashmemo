# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    text { Faker::Lorem.sentence }
    association :question
  end
end
