FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Lorem.word }
  end
end
