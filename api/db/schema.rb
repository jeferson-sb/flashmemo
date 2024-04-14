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

ActiveRecord::Schema[7.0].define(version: 2024_03_30_215658) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score"
    t.bigint "user_id"
    t.bigint "exam_id"
    t.datetime "last_attempted_at"
    t.integer "interval_level", default: 0
    t.index ["exam_id"], name: "index_answers_on_exam_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "health", default: 100
    t.bigint "tree_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tree_id"], name: "index_branches_on_tree_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exams", force: :cascade do |t|
    t.string "title"
    t.integer "difficulty", default: 0
    t.integer "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_exams_on_category_id"
  end

  create_table "exams_questions", id: false, force: :cascade do |t|
    t.bigint "exam_id"
    t.bigint "question_id"
    t.index ["exam_id", "question_id"], name: "index_exams_questions_on_exam_id_and_question_id", unique: true
    t.index ["exam_id"], name: "index_exams_questions_on_exam_id"
    t.index ["question_id"], name: "index_exams_questions_on_question_id"
  end

  create_table "gardens", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.integer "seeds", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_gardens_on_user_id"
  end

  create_table "options", force: :cascade do |t|
    t.string "text"
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "correct", default: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "exam_id"
    t.bigint "revision_id"
    t.boolean "has_duo", default: false
    t.index ["exam_id"], name: "index_questions_on_exam_id"
    t.index ["revision_id"], name: "index_questions_on_revision_id"
  end

  create_table "revisions", force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_revisions_on_exam_id"
    t.index ["user_id"], name: "index_revisions_on_user_id"
  end

  create_table "trees", force: :cascade do |t|
    t.string "name"
    t.integer "phase", default: 0
    t.integer "health", default: 100
    t.bigint "garden_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["garden_id"], name: "index_trees_on_garden_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "exams"
  add_foreign_key "answers", "users"
  add_foreign_key "branches", "trees"
  add_foreign_key "exams", "categories"
  add_foreign_key "exams_questions", "exams"
  add_foreign_key "exams_questions", "questions"
  add_foreign_key "gardens", "users"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "exams"
  add_foreign_key "questions", "revisions"
  add_foreign_key "revisions", "exams"
  add_foreign_key "revisions", "users"
  add_foreign_key "trees", "gardens"
end
