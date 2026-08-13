# frozen_string_literal: true

json.id @garden.id
json.user_id @garden.user_id
json.bucket_seeds @garden.seeds
json.nutrients @garden.nutrients
json.name @garden.name

json.trees @garden.trees do |tree|
  json.id tree.id
  json.name tree.name
  json.phase tree.phase
  json.health tree.health
end
