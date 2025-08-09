# frozen_string_literal: true

FactoryBot.define do
  factory :edge do
    association :from_node, factory: :node
    association :to_node, factory: :node
  end
end
