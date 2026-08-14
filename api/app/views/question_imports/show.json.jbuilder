# frozen_string_literal: true

json.id @question_import.id
json.exam_id @question_import.exam_id
json.status @question_import.status
json.filename @question_import.filename
json.total_rows @question_import.total_rows
json.imported_count @question_import.imported_count
json.skipped_count @question_import.skipped_count
json.failed_count @question_import.failed_count
json.failure_reason @question_import.failure_reason
json.created_at @question_import.created_at

json.row_errors @question_import.row_errors do |row_error|
  json.row row_error['row']
  json.title row_error['title']
  json.reason row_error['reason']
end
