# frozen_string_literal: true

json.id @exam.id
json.title @exam.title
json.level @exam.difficulty

json.total @exam.questions.length

json.category Category.find(@exam.category_id).title if @exam.category_id.present?

json.questions @exam.questions do |question|
  json.id question.id
  json.title question.title
  json.is_duo question.has_duo
  json.options question.options do |option|
    json.id option.id
    json.text option.text
  end
end
