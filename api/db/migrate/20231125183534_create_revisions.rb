class CreateRevisions < ActiveRecord::Migration[7.0]
  def change
    create_table :revisions do |t|
      t.references :exam, null: false, index: true, foreign_key: true
      t.references :user, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
