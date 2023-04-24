FactoryBot.define do
  factory :question do
    title { Faker::Lorem.question }
  end
end
