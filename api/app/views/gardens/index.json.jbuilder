
json.array! @gardens do |garden|
  json.id garden.id
  json.name garden.name
  json.bucket_seeds garden.seeds
  json.trees garden.trees.length
end
