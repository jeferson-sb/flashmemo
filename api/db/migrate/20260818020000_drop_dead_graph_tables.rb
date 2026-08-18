# frozen_string_literal: true

class DropDeadGraphTables < ActiveRecord::Migration[8.0]
  # nodes/edges were an early, Postgres-only sketch of the mind-map graph.
  # ExamNode/CategoryNode (app/models/exam_node.rb, category_node.rb) replaced
  # it with real Neo4j nodes and relationships; nothing in the app has ever
  # read from or written to these two tables.
  def up
    drop_table :edges
    drop_table :nodes
  end

  def down
    create_table :nodes do |t|
      t.string :nodeable_type, null: false
      t.bigint :nodeable_id, null: false
      t.integer :position
      t.integer :graph_id
      t.timestamps
    end
    add_index :nodes, %i[nodeable_type nodeable_id], name: 'index_nodes_on_nodeable'
    add_index :nodes, %i[nodeable_type nodeable_id], unique: true,
                                                       name: 'index_nodes_on_nodeable_type_and_nodeable_id'

    create_table :edges do |t|
      t.bigint :from_node_id, null: false
      t.bigint :to_node_id, null: false
      t.timestamps
    end
    add_index :edges, %i[from_node_id to_node_id], unique: true
    add_index :edges, :from_node_id
    add_index :edges, :to_node_id
    add_foreign_key :edges, :nodes, column: :from_node_id
    add_foreign_key :edges, :nodes, column: :to_node_id
  end
end
