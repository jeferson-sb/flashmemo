# frozen_string_literal: true

module Questions
  # Fills an exam from an uploaded spreadsheet. Rows are independent: a bad row
  # is recorded in the import's row_errors and the rest still land, so a single
  # typo never costs the whole file. Rows whose title already exists in the exam
  # are skipped rather than duplicated, which makes re-uploading a corrected
  # sheet safe.
  class Import
    class << self
      def perform(question_import)
        question_import.processing!

        question_import.file.open do |file|
          sheet = Spreadsheets::QuestionSheet.open(file.path)
          import_rows(question_import, sheet.rows)
        end
      rescue StandardError => e
        question_import.update!(status: :failed, failure_reason: e.message)
      end

      private

      def import_rows(question_import, rows)
        exam = question_import.exam
        seen = existing_titles(exam)
        tally = { imported: 0, skipped: 0, errors: [] }

        rows.each { |row| process_row(exam, row, seen, tally) }

        finish(question_import, rows.size, tally)
      end

      def process_row(exam, row, seen, tally)
        return tally[:errors] << error_entry(row, row.error) if row.error

        title = normalize(row.title)
        return tally[:skipped] += 1 if seen.include?(title)

        create_question(exam, row)
        seen << title
        tally[:imported] += 1
      rescue ActiveRecord::RecordInvalid => e
        tally[:errors] << error_entry(row, e.record.errors.full_messages.to_sentence)
      end

      # Mirrors ExamsController#create: the join table and the legacy
      # questions.exam_id column are both written, so every existing reader
      # (jbuilder views, Exams::Evaluate, revisions) sees the question.
      def create_question(exam, row)
        question = Question.new(title: row.title, exam_id: exam.id)
        question.options.build(row.options)
        question.save!

        exam.questions << question
      end

      def finish(question_import, total, tally)
        question_import.update!(
          status: :completed,
          total_rows: total,
          imported_count: tally[:imported],
          skipped_count: tally[:skipped],
          failed_count: tally[:errors].size,
          row_errors: tally[:errors]
        )
      end

      def existing_titles(exam)
        exam.questions.pluck(:title).map { |title| normalize(title) }.to_set
      end

      def error_entry(row, reason)
        { row: row.number, title: row.title.presence || '—', reason: }
      end

      def normalize(title)
        title.to_s.strip.downcase
      end
    end
  end
end
