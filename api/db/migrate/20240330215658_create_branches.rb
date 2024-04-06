class CreateBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :branches do |t|
      t.string :name, unique: true
      t.text :description
      t.integer :health, default: 100
      t.references :tree, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
