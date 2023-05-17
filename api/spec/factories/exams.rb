FactoryBot.define do
  factory :exam do
    title { Faker::Lorem.word }
    difficulty { %i[beginner intermediate advanced].sample }
    version { 1 }
  end
end