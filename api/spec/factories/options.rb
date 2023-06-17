FactoryBot.define do
  factory :option do
    text { Faker::Lorem.sentence }
    association :question

    trait :correct_option do
      correct { true }
    end
  end
end
