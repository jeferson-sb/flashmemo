# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'QuestionImports', type: :request do
  include ActiveJob::TestHelper

  let(:json_body) { JSON.parse(response.body) }
  let(:user) { create(:user) }
  let(:exam) { create(:exam, user:) }
  let(:headers) { auth_headers_for(user) }

  def upload(name, type = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    fixture_file_upload("files/#{name}", type)
  end

  def post_import(name, type = nil)
    file = type ? upload(name, type) : upload(name)
    post("/api/exams/#{exam.id}/imports", params: { file: }, headers:)
  end

  describe 'POST /api/exams/:exam_id/imports' do
    it 'requires authentication' do
      post "/api/exams/#{exam.id}/imports", params: { file: upload('questions.xlsx') }

      expect(response).to have_http_status(:unauthorized)
    end

    context 'with a well-formed spreadsheet' do
      before { post_import('questions.xlsx') }

      it 'accepts the upload for background processing' do
        expect(response).to have_http_status(:accepted)
      end

      it 'returns the import to poll' do
        expect(json_body).to include('id', 'status' => 'pending')
      end

      it 'keeps the original filename' do
        expect(json_body['filename']).to eq('questions.xlsx')
      end

      it 'stores the file against the import' do
        expect(QuestionImport.last.file).to be_attached
      end

      it 'records who uploaded it' do
        expect(QuestionImport.last.user).to eq(user)
      end

      it 'enqueues the import job' do
        expect(ImportQuestionsJob).to have_been_enqueued.with(QuestionImport.last.id)
      end
    end

    context 'when the file is not a spreadsheet' do
      before { post_import('not_a_spreadsheet.txt', 'text/plain') }

      it 'rejects it' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body['error']).to eq([I18n.t('imports.errors.wrong_extension')])
      end

      it 'does not enqueue anything' do
        expect(ImportQuestionsJob).not_to have_been_enqueued
      end

      it 'does not store an import' do
        expect(QuestionImport.count).to eq(0)
      end
    end

    context 'when the header row is wrong' do
      before { post_import('wrong_columns.xlsx') }

      it 'names the missing columns instead of queueing the work' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body['error'].first).to include('title', 'option_a', 'option_b', 'correct')
      end

      it 'does not enqueue anything' do
        expect(ImportQuestionsJob).not_to have_been_enqueued
      end
    end

    context 'when the exam belongs to someone else' do
      let(:someone_elses_exam) { create(:exam) }

      before do
        post("/api/exams/#{someone_elses_exam.id}/imports", params: { file: upload('questions.xlsx') }, headers:)
      end

      it 'refuses the upload' do
        expect(response).to have_http_status(:not_found)
      end

      it 'does not store an import or enqueue work' do
        expect(QuestionImport.count).to eq(0)
        expect(ImportQuestionsJob).not_to have_been_enqueued
      end
    end

    context 'when no file is attached' do
      before { post "/api/exams/#{exam.id}/imports", headers: }

      it 'says so' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body['error']).to eq([I18n.t('imports.errors.missing_file')])
      end
    end
  end

  describe 'GET /api/imports/:id' do
    let(:question_import) do
      create(:question_import, exam:, user:, status: :completed, total_rows: 11, imported_count: 4,
                               skipped_count: 1, failed_count: 6,
                               row_errors: [{ row: 8, title: 'Row with only one option', reason: 'too few' }])
    end

    it 'reports progress to the uploader' do
      get("/api/imports/#{question_import.id}", headers:)

      expect(response).to be_successful
      expect(json_body).to include('status' => 'completed', 'imported_count' => 4, 'skipped_count' => 1,
                                   'failed_count' => 6)
    end

    it 'includes the failed rows' do
      get("/api/imports/#{question_import.id}", headers:)

      expect(json_body['row_errors'].first).to eq('row' => 8, 'title' => 'Row with only one option',
                                                  'reason' => 'too few')
    end

    it 'hides imports belonging to someone else' do
      get "/api/imports/#{question_import.id}", headers: auth_headers

      expect(response).to have_http_status(:not_found)
    end

    it 'requires authentication' do
      get "/api/imports/#{question_import.id}"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
