# frozen_string_literal: true

class AddSurpriseQuestionAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :surprise_question_answers do |t|
      t.references :question, null: false, index: true, foreign_key: true
      t.references :user, null: false, index: true, foreign_key: true
      t.boolean :winner, default: false

      t.timestamps
    end
  end
end
