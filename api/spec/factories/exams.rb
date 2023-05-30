FactoryBot.define do
  factory :exam do
    title { Faker::Lorem.word }
    difficulty { %i[beginner intermediate advanced].sample }
    version { 1 }
    trait :with_questions do
      after(:create) { |exam| create_list(:question, 3, exam:) }
    end
  end
end
