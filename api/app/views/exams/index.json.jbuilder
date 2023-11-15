# frozen_string_literal: true

json.array! @exams do |exam|
  json.id exam.id
  json.title exam.title
  json.level exam.created_at
  json.total_questions exam.questions.length
end
