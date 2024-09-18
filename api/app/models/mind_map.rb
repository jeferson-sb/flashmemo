# frozen_string_literal: true

class MindMap < ApplicationRecord
  belongs_to :category
  has_many :nodes, foreign_key: 'graph_id'

  validates :name, presence: true

  scope :for_category, ->(category) { where(category_id: category.id) }

  def add_node(node)
    node.update!(graph_id: id)
  end

  def remove_node(node)
    node.update!(graph_id: nil)
  end

  def connect_nodes(from, to)
    Edge.create(from_node: from, to_node: to)
  end
end
