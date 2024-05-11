# frozen_string_literal: true

json.id @revision.id
json.exam_id @revision.exam_id
json.user_id @revision.user_id
json.interval_level @revision.interval_level
json.questions @revision.questions

json.created_at @revision.created_at
json.updated_at @revision.updated_at
