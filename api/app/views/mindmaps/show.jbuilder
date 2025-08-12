# frozen_string_literal: true

json.message 'Your mind map'
json.name @mm.name
json.category @mm.category.title
json.nodes @mm.node_ids
