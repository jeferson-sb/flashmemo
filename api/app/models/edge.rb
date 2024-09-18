# frozen_string_literal: true

class Edge < ApplicationRecord
  belongs_to :from_node, class_name: 'Node'
  belongs_to :to_node, class_name: 'Node'

  validates :from_node_id, presence: true
  validates :to_node_id, presence: true

  scope :between, ->(from, to) { where(from_node_id: from.id, to_node_id: to.id) }
end
