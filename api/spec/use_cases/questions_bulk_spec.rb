# frozen_string_literal: true

RSpec.describe Questions::Bulk do
  describe '#create' do
    describe 'when valid options' do
      it 'create list of questions' do
        valid_options = [
          {
            text: Faker::Lorem.sentence,
            correct: true
          },
          {
            text: Faker::Lorem.sentence,
            correct: false
          }
        ]
        questions = [
          {
            title: Faker::Lorem.question,
            options: valid_options
          },
          {
            title: Faker::Lorem.question,
            options: valid_options
          }
        ]
        Questions::Bulk.create(questions)

        expect(Question.count).to eq(2)
        expect(Option.count).to eq(4)
      end
    end

    describe 'when invalid options' do
      it 'fail validation and rollback' do
        options = [
          {
            text: Faker::Lorem.sentence,
            correct: true
          }
        ]
        questions = [
          {
            title: Faker::Lorem.question,
            options:
          }
        ]

        expect { Questions::Bulk.create(questions) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
