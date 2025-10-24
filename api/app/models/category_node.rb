class CategoryNode
  include ActiveGraph::Node

  property :name
  property :category_id
  property :mindmap_id

  scope :by_mindmap, ->(mindmap_id) { where(mindmap_id: mindmap_id) }

  has_many :in, :exams, origin: :category, model_class: 'ExamNode'
  has_many :out, :categories, type: :RELATES_TO, model_class: self, labels: false
end
