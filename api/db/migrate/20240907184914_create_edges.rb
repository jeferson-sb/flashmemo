# frozen_string_literal: true

class CreateEdges < ActiveRecord::Migration[7.0]
  def change
    create_table :edges do |t|
      t.references :from_node, null: false, foreign_key: { to_table: :nodes }
      t.references :to_node, null: false, foreign_key: { to_table: :nodes }

      t.timestamps
    end

    add_index :edges, %i[from_node_id to_node_id], name: 'index_edges_on_from_node_id_and_to_node_id', unique: true
  end
end
