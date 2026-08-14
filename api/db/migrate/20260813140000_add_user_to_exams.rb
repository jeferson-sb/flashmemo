# frozen_string_literal: true

class AddUserToExams < ActiveRecord::Migration[8.0]
  # Exams predate any notion of an owner, so there is no honest backfill for
  # user_id — picking an arbitrary account would hand one user everyone
  # else's work. The existing exam set is dropped instead, and with it every
  # row that only makes sense alongside an exam: attempts, revisions,
  # question imports and the question bank itself. Users, gardens, trees,
  # categories and mind maps are untouched.
  def up
    execute <<~SQL.squish
      DELETE FROM active_storage_attachments WHERE record_type IN ('QuestionImport', 'Question');
    SQL
    execute 'DELETE FROM question_imports'
    execute 'DELETE FROM surprise_question_answers'
    execute 'DELETE FROM answers'
    execute 'DELETE FROM exams_questions'
    execute 'DELETE FROM options'
    execute 'DELETE FROM questions'
    execute 'DELETE FROM revisions'
    execute 'DELETE FROM exams'

    add_reference :exams, :user, null: false, foreign_key: true
  end

  def down
    remove_reference :exams, :user, foreign_key: true
  end
end
