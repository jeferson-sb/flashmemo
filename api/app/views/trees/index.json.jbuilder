# frozen_string_literal: true

json.array! @trees do |tree|
  json.id tree.id
  json.name tree.name
  json.phase tree.phase
  json.health tree.health
end
