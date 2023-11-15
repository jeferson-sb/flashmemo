# frozen_string_literal: true

json.id @exam.id
json.title @exam.title
json.level @exam.difficulty

json.total @exam.questions.length

if @exam.category_id.present?
  json.category Category.find(@exam.category_id).title
end

json.questions @exam.questions do |question|
  json.id question.id
  json.title question.title
  json.options question.options do |option|
    json.id option.id
    json.text option.text
    json.correct option.correct
  end
end
