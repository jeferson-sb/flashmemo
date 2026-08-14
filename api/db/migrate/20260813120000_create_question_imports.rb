# frozen_string_literal: true

class CreateQuestionImports < ActiveRecord::Migration[8.0]
  def change
    create_table :question_imports do |t|
      t.references :exam, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.string :filename
      t.integer :total_rows, null: false, default: 0
      t.integer :imported_count, null: false, default: 0
      t.integer :skipped_count, null: false, default: 0
      t.integer :failed_count, null: false, default: 0
      # One entry per rejected row: { row:, title:, reason: }. Named row_errors
      # because `errors` would shadow ActiveModel::Validations#errors.
      t.jsonb :row_errors, null: false, default: []
      t.text :failure_reason

      t.timestamps
    end
  end
end
