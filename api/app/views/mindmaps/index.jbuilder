# frozen_string_literal: true

json.array! @mmaps do |map|
  json.id map.id
  json.name map.name
  json.owner_id map.user_id
  json.node_count map.node_ids.count
end
