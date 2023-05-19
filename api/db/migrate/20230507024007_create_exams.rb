class CreateExams < ActiveRecord::Migration[7.0]
  def change
    create_table :exams do |t|
      t.string :title, unique: true
      t.integer :difficulty, default: 0
      t.integer :version

      t.timestamps
    end
  end
end
