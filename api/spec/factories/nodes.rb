# frozen_string_literal: true

FactoryBot.define do
  factory :node do
    nodeable_type { "Exam" }
    nodeable_id { create(:exam).id }
    position { Faker::Number.between(from: 0, to: 100) }
  end
end
