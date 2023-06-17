class CreateExamsQuestionsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :exams_questions, id: false do |t|
      t.references :exam, foreign_key: true
      t.references :question, foreign_key: true
    end

    add_index :exams_questions, %i[exam_id question_id], unique: true
  end
end
