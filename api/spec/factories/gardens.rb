FactoryBot.define do
  factory :garden do
    name { Faker::Name.name }
    seeds { 0 }

    association :user
  end
end
