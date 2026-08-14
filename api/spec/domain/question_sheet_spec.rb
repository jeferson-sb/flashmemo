# frozen_string_literal: true

require 'rails_helper'

# spec/fixtures/files/questions.xlsx is a real workbook laid out as
# title | option_a..option_e | correct, holding four importable rows, one
# duplicate of an earlier title, and one row per rejection reason.
RSpec.describe Spreadsheets::QuestionSheet do
  subject(:sheet) { described_class.open(fixture_path('questions.xlsx')) }

  def fixture_path(name)
    Rails.root.join('spec/fixtures/files', name).to_s
  end

  def row_titled(title)
    sheet.rows.find { |row| row.title == title }
  end

  describe '.open' do
    it 'raises UnreadableFile when the file is not a spreadsheet' do
      expect { described_class.open(fixture_path('not_a_spreadsheet.txt')) }
        .to raise_error(described_class::UnreadableFile)
    end
  end

  describe '#missing_headers' do
    it 'is empty for a well-formed sheet' do
      expect(sheet.missing_headers).to be_empty
    end

    it 'lists the required columns the sheet lacks' do
      other = described_class.open(fixture_path('wrong_columns.xlsx'))

      expect(other.missing_headers).to contain_exactly('title', 'option_a', 'option_b', 'correct')
    end
  end

  describe '#row_count' do
    it 'counts data rows, excluding the header' do
      expect(sheet.row_count).to eq(11)
    end

    it 'is within the import limit' do
      expect(sheet).not_to be_too_many_rows
    end
  end

  describe '#rows' do
    it 'parses every data row' do
      expect(sheet.rows.size).to eq(11)
    end

    it 'numbers rows as they appear in the spreadsheet' do
      expect(sheet.rows.first.number).to eq(2)
    end

    it 'keeps only the options that were filled in' do
      row = row_titled('Which queue adapter ships with Rails 8?')

      expect(row.options.map { |option| option[:text] }).to eq(['Sidekiq', 'Solid Queue', 'Resque'])
    end

    it 'marks the option named by the answer key as correct' do
      row = row_titled('Which queue adapter ships with Rails 8?')

      expect(row.options.find { |option| option[:correct] }[:text]).to eq('Solid Queue')
    end

    it 'accepts all five option columns' do
      row = row_titled('Name the five SQL join types')

      expect(row.options.size).to eq(5)
      expect(row.options.last).to include(text: 'CROSS', correct: true)
    end

    it 'accepts a lowercase answer key' do
      row = row_titled('Lowercase answer letters are accepted')

      expect(row).to be_valid
      expect(row.options.first).to include(text: 'Yes', correct: true)
    end

    it 'rejects a row with no title' do
      row = sheet.rows.find { |r| r.title.blank? }

      expect(row.error).to eq(I18n.t('imports.errors.missing_title'))
    end

    it 'rejects a row with a single option' do
      expect(row_titled('Row with only one option').error).to eq(I18n.t('imports.errors.too_few_options'))
    end

    it 'rejects a row with no answer key' do
      expect(row_titled('Row with no answer key').error).to eq(I18n.t('imports.errors.missing_correct'))
    end

    it 'rejects an answer key that is not a letter between A and E' do
      expect(row_titled('Row with a nonsense answer key').error)
        .to eq(I18n.t('imports.errors.invalid_correct', value: 'Z'))
    end

    it 'rejects an answer key pointing past the filled options' do
      expect(row_titled('Row whose key points past the options').error)
        .to eq(I18n.t('imports.errors.correct_out_of_range', letter: 'D', count: 2))
    end

    it 'rejects a row with a gap between options, which would shift the answer key' do
      expect(row_titled('Row with a hole in the options').error).to eq(I18n.t('imports.errors.blank_option'))
    end

    it 'leaves valid rows without an error' do
      expect(row_titled('What does HABTM stand for?')).to be_valid
    end
  end
end
