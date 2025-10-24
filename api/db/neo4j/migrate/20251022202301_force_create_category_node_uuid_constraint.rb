class ForceCreateCategoryNodeUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :CategoryNode, :uuid, force: true
  end

  def down
    drop_constraint :CategoryNode, :uuid
  end
end
