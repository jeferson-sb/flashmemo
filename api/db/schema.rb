# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_230_607_033_605) do
  create_table 'answers', force: :cascade do |t|
    t.string 'text'
    t.integer 'question_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['question_id'], name: 'index_answers_on_question_id'
  end

  create_table 'exams', force: :cascade do |t|
    t.string 'title'
    t.integer 'difficulty', default: 0
    t.integer 'version'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'exams_questions', id: false, force: :cascade do |t|
    t.integer 'exam_id'
    t.integer 'question_id'
    t.index %w[exam_id question_id], name: 'index_exams_questions_on_exam_id_and_question_id', unique: true
    t.index ['exam_id'], name: 'index_exams_questions_on_exam_id'
    t.index ['question_id'], name: 'index_exams_questions_on_question_id'
  end

  create_table 'options', force: :cascade do |t|
    t.string 'text'
    t.integer 'question_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'correct', default: false
    t.index ['question_id'], name: 'index_options_on_question_id'
  end

  create_table 'questions', force: :cascade do |t|
    t.string 'title'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'exam_id'
    t.index ['exam_id'], name: 'index_questions_on_exam_id'
  end

  add_foreign_key 'answers', 'questions'
  add_foreign_key 'exams_questions', 'exams'
  add_foreign_key 'exams_questions', 'questions'
  add_foreign_key 'options', 'questions'
  add_foreign_key 'questions', 'exams'
end
