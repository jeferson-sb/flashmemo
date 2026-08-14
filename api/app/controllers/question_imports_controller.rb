# frozen_string_literal: true

class QuestionImportsController < ApplicationController
  # Everything wrong with the file as a *file* — wrong type, too big, missing
  # header row — is answered synchronously, so an obviously wrong upload never
  # costs a job slot or a poll cycle. Row-level problems belong to the job.
  def create
    @exam = Exam.find(params[:exam_id])
    file = params[:file]
    error = preflight(file)

    return render json: { error: [error] }, status: :unprocessable_entity if error

    @question_import = build_import(file)
    ImportQuestionsJob.perform_later(@question_import.id)

    render :show, formats: :json, status: :accepted
  end

  def show
    @question_import = QuestionImport.for_user(Current.user.id).find(params[:id])

    render :show, formats: :json
  end

  private

  def build_import(file)
    QuestionImport.create!(exam: @exam, user: Current.user, filename: file.original_filename).tap do |import|
      file.tempfile.rewind
      import.file.attach(file)
    end
  end

  def preflight(file)
    return I18n.t('imports.errors.missing_file') unless file.respond_to?(:original_filename)
    return I18n.t('imports.errors.wrong_extension') unless xlsx?(file.original_filename)

    if file.size > QuestionImport::MAX_FILE_SIZE
      return I18n.t('imports.errors.too_large',
                    max: QuestionImport::MAX_FILE_SIZE / 1.megabyte)
    end

    sheet_error(file)
  end

  def sheet_error(file)
    sheet = Spreadsheets::QuestionSheet.open(file.tempfile.path)
    missing = sheet.missing_headers

    return I18n.t('imports.errors.missing_headers', headers: missing.join(', ')) if missing.any?
    return I18n.t('imports.errors.too_many_rows', max: Spreadsheets::QuestionSheet::MAX_ROWS) if sheet.too_many_rows?

    I18n.t('imports.errors.empty_sheet') if sheet.row_count.zero?
  rescue Spreadsheets::QuestionSheet::UnreadableFile
    I18n.t('imports.errors.unreadable')
  end

  def xlsx?(filename)
    File.extname(filename).downcase == QuestionImport::ACCEPTED_EXTENSION
  end
end
