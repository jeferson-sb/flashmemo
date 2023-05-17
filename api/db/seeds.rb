5.times do |i|
  Question.create(title: Faker::Lorem.question)
end

10.times do |i|
  Option.create(text: Faker::Lorem.sentence, correct: false, question_id: Question.pluck(:id).sample)
end
