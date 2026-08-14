# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Questions::Import do
  subject(:question_import) { create(:question_import, :with_file, exam:) }

  let(:exam) { create(:exam) }

  describe '.perform' do
    context 'with the example spreadsheet' do
      before { described_class.perform(question_import) }

      it 'completes' do
        expect(question_import.reload).to be_completed
      end

      it 'imports every valid row' do
        expect(question_import.reload.imported_count).to eq(4)
      end

      it 'reports the rows it could not read' do
        expect(question_import.reload.failed_count).to eq(6)
      end

      it 'records the spreadsheet row number and reason for each failure' do
        failure = question_import.reload.row_errors.find { |error| error['title'] == 'Row with only one option' }

        expect(failure).to include('row' => 8, 'reason' => I18n.t('imports.errors.too_few_options'))
      end

      it 'attaches the imported questions to the exam' do
        expect(exam.reload.questions.count).to eq(4)
      end

      it 'also writes the legacy questions.exam_id column' do
        expect(exam.reload.questions.pluck(:exam_id).uniq).to eq([exam.id])
      end

      it 'builds the options named in the sheet' do
        question = exam.reload.questions.find_by(title: 'Which queue adapter ships with Rails 8?')

        expect(question.options.pluck(:text)).to eq(['Sidekiq', 'Solid Queue', 'Resque'])
      end

      it 'marks the option named by the answer key' do
        question = exam.reload.questions.find_by(title: 'Which queue adapter ships with Rails 8?')

        expect(question.options.find_by(correct: true).text).to eq('Solid Queue')
      end
    end

    context 'when a title in the sheet repeats' do
      before { described_class.perform(question_import) }

      it 'skips the repeat rather than duplicating it' do
        expect(question_import.reload.skipped_count).to eq(1)
      end

      it 'keeps a single copy of the question' do
        expect(exam.reload.questions.where(title: 'What does HABTM stand for?').count).to eq(1)
      end
    end

    context 'when the same sheet is imported twice' do
      before do
        described_class.perform(question_import)
        described_class.perform(create(:question_import, :with_file, exam:))
      end

      it 'adds nothing the second time' do
        expect(exam.reload.questions.count).to eq(4)
      end

      it 'reports every already-present row as skipped' do
        expect(QuestionImport.order(:id).last.skipped_count).to eq(5)
      end
    end

    context 'when the attached file cannot be read' do
      subject(:question_import) do
        create(:question_import, :with_file, exam:, fixture: 'not_a_spreadsheet.txt')
      end

      before { described_class.perform(question_import) }

      it 'fails instead of raising' do
        expect(question_import.reload).to be_failed
      end

      it 'keeps the reason for support' do
        expect(question_import.reload.failure_reason).to be_present
      end
    end
  end
end
