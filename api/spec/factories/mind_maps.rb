# frozen_string_literal: true

FactoryBot.define do
  factory :mind_map do
    name { Faker::Name.name }
  
    category { create(:category) }
    nodes { build_list(:node, 2) }
    
    association :user
  end
end
