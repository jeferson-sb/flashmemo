# frozen_string_literal: true

class Node < ApplicationRecord
  belongs_to :nodeable, polymorphic: true
  belongs_to :graph, class_name: 'MindMap', foreign_key: 'graph_id', optional: true

  has_many :edges, dependent: :destroy
  has_many :edges, foreign_key: 'from_node_id'

  validates :nodeable_type, presence: true
  validates :nodeable_id, presence: true

  scope :related_to_exam, ->(exam) { where(nodeable_type: 'Exam', nodeable_id: exam.id) }
end
