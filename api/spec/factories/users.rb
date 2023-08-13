FactoryBot.define do
  factory :user do
    username { "MyString" }
    email { "MyString" }
    password { "MyString" }
    last_submission { 1 }
  end
end
