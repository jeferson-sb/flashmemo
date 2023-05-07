FactoryBot.define do
  factory :answer do
    text { Faker::Lorem.sentence }
    association :question
  end
end
