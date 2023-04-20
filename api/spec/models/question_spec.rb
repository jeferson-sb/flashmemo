require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { Question.create(title: 'What is RSPec?') }

  it 'has title attribute' do
    question = Question.create(title: 'What is Ruby?')
    expect(question.title).to eq('What is Ruby?')
  end 

  context 'when option created' do
    it 'has options attributes' do
      question = Question.create(title: 'question1')
      firstOption = Option.create(text: 'answer 1', correct: false, question: Question.first)
      secondOption = Option.create(text: 'answer 2', correct: true, question: Question.first)

      expect(question.options.length).to eq(2)
    end 
  end 
end
