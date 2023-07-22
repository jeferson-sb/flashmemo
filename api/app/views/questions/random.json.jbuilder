# frozen_string_literal: true

json.id @question.id
json.title @question.title

json.options @question.options do |option|
  json.text option.text
  json.correct option.correct
end
