# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    score { rand(1..100) }

    association :user
    association :exam
  end
end
