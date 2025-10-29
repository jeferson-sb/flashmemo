class ForceCreateCategoryNodeUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :CategoryNode, :uuid, force: true
    add_index      :CategoryNode, :name
  end

  def down
    drop_constraint :CategoryNode, :uuid
    drop_index      :CategoryNode, :name
  end
end
