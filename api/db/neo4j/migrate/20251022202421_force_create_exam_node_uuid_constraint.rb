class ForceCreateExamNodeUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :ExamNode, :uuid, force: true
    add_index      :ExamNode, :name
  end

  def down
    drop_constraint :ExamNode, :uuid
    drop_index      :ExamNode, :name
  end
end
