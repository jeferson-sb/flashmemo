class CreateGardens < ActiveRecord::Migration[7.0]
  def change
    create_table :gardens do |t|
      t.string :name
      t.references :user, null: false, index: true, foreign_key: true
      t.integer :seeds, default: 0

      t.timestamps
    end
  end
end
