class CreateTrees < ActiveRecord::Migration[7.0]
  def change
    create_table :trees do |t|
      t.string :name, unique: true
      t.integer :phase, default: 0
      t.integer :health, default: 100
      t.references :garden, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
