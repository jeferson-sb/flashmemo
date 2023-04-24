FactoryBot.define do
  factory :option do
    text { Faker::Lorem.sentence }
    association :question
  end
end
