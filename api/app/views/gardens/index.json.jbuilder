# frozen_string_literal: true

json.array! @gardens do |garden|
  json.id garden.id
  json.name garden.name
  json.user_id garden.user_id
  json.bucket_seeds garden.seeds
  json.trees garden.trees.length
end
