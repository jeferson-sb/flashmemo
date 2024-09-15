# frozen_string_literal: true

class CreateMindMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :mind_maps do |t|
      t.string :name
      t.references :category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
