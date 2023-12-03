# frozen_string_literal: true

FactoryBot.define do
  factory :revision do
    association :user
    association :exam
  end
end
