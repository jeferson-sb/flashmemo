class ForceCreateExamNodeUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :ExamNode, :uuid, force: true
  end

  def down
    drop_constraint :ExamNode, :uuid
  end
end
