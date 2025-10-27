# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    settings { {"language" => Faker::Address.country_code, "tz" => Time.zone.name, "country" => Faker::Address.country_code} }
    association :user
  end
end
