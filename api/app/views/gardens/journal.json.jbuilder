# frozen_string_literal: true

json.message I18n.t('daily_journal')
json.today Date.today
json.trees_count @garden.trees.count
json.stock do
  json.seeds @garden.seeds
  json.nutrients @garden.nutrients
end
json.monthly_progress_score @score || 0

if @surprise_question
  json.surprise_question do
    json.id @surprise_question.id
    json.title @surprise_question.title
    json.active_days @surprise_question.is_limited_between
  end
end
