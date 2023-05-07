FactoryBot.define do
  factory :question do
    title { Faker::Lorem.question }
    trait :with_options do
      after(:create) { |question| create_list(:option, 3, question:) }
    end
  end
end
