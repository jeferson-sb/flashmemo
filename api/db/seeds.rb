5.times do |_i|
  Question.create(title: Faker::Lorem.question)
end

10.times do |_i|
  Option.create(text: Faker::Lorem.sentence, correct: false, question_id: Question.pluck(:id).sample)
end
