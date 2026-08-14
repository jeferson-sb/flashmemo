# frozen_string_literal: true

FactoryBot.define do
  factory :question_import do
    exam
    user
    filename { 'questions.xlsx' }

    transient do
      fixture { 'questions.xlsx' }
    end

    trait :with_file do
      after(:build) do |question_import, evaluator|
        question_import.file.attach(
          io: Rails.root.join('spec/fixtures/files', evaluator.fixture).open,
          filename: evaluator.fixture,
          content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )
      end
    end
  end
end
