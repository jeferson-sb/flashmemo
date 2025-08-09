# frozen_string_literal: true

class CreateNodes < ActiveRecord::Migration[7.0]
  def change
    create_table :nodes do |t|
      t.references :nodeable, polymorphic: true, null: false
      t.integer :position

      t.timestamps
    end

    add_index :nodes, %i[nodeable_type nodeable_id], name: 'index_nodes_on_nodeable_type_and_nodeable_id', unique: true
  end
end
