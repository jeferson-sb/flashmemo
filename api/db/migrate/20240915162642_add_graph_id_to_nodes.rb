# frozen_string_literal: true

class AddGraphIdToNodes < ActiveRecord::Migration[7.0]
  def change
    add_column :nodes, :graph_id, :integer
  end
end
