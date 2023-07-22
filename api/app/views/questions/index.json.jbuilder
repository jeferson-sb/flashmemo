# frozen_string_literal: true

json.array! @questions do |question|
  json.id question.id
  json.title question.title
  json.created_at question.created_at
end
