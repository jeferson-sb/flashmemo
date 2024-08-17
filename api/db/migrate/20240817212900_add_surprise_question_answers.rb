class AddSurpriseQuestionAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :surprise_question_answers do |t|
      t.references :question, null: false, index: true, foreign_key: true
      t.references :user, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
