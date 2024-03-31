FactoryBot.define do
  factory :tree do
    name { Faker::Name.name }
    phase { %i[seed growing mature fall].sample }
    health { 100 }

    association :garden
  end
end
