class ExamNode
  include ActiveGraph::Node

  property :name
  property :exam_id
  property :mindmap_id

  has_many :out, :related, type: :RELATES_TO, model_class: self, labels: false
  has_many :out, :category, type: :IN, model_class: 'CategoryNode', labels: false
end
