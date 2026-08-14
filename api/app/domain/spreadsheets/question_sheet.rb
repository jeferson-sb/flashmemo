# frozen_string_literal: true

require 'roo'

module Spreadsheets
  # Reads a multiple-choice question sheet laid out one question per row:
  #
  #   title | option_a | option_b | option_c | option_d | option_e | correct
  #
  # `correct` holds the letter of the right option (A-E). Columns are matched
  # by header name, not position, so column order is free. Every row is graded
  # here into a valid Row or a Row carrying the reason it was rejected — this
  # class never touches the database.
  class QuestionSheet
    TITLE_HEADER = 'title'
    CORRECT_HEADER = 'correct'
    OPTION_HEADERS = %w[option_a option_b option_c option_d option_e].freeze
    REQUIRED_HEADERS = [TITLE_HEADER, 'option_a', 'option_b', CORRECT_HEADER].freeze
    MAX_ROWS = 500
    HEADER_ROW = 1

    Row = Struct.new(:number, :title, :options, :error, keyword_init: true) do
      def valid?
        error.nil?
      end
    end

    class << self
      def open(path)
        new(Roo::Excelx.new(path, file_warning: :ignore))
      rescue StandardError => e
        raise UnreadableFile, e.message
      end
    end

    class UnreadableFile < StandardError; end

    def initialize(workbook)
      @sheet = workbook.sheet(0)
    end

    def headers
      @headers ||= header_cells.map { |cell| normalize(cell) }
    end

    def missing_headers
      REQUIRED_HEADERS - headers
    end

    def row_count
      [@sheet.last_row.to_i - HEADER_ROW, 0].max
    end

    def too_many_rows?
      row_count > MAX_ROWS
    end

    def rows
      ((HEADER_ROW + 1)..@sheet.last_row.to_i).filter_map do |number|
        cells = cells_for(number)
        next if cells.values.all? { |value| value.blank? }

        build_row(number, cells)
      end
    end

    private

    def header_cells
      return [] if @sheet.last_row.nil?

      @sheet.row(HEADER_ROW) || []
    end

    def cells_for(number)
      values = @sheet.row(number) || []
      headers.each_with_index.to_h { |header, index| [header, stringify(values[index])] }
    end

    def build_row(number, cells)
      title = cells[TITLE_HEADER]
      correct = cells[CORRECT_HEADER]
      texts = options_for(cells)
      error = row_error(title, texts, correct)

      Row.new(number:, title:, options: error ? [] : build_options(texts, correct), error:)
    end

    def build_options(texts, correct)
      index = letter_index(correct.upcase)

      texts.each_with_index.map { |text, position| { text:, correct: position == index } }
    end

    # Blank cells between filled ones would silently shift the answer key, so
    # positions are kept and only trailing blanks fall away.
    def options_for(cells)
      texts = OPTION_HEADERS.map { |header| cells[header] }
      texts.pop while texts.any? && texts.last.blank?
      texts
    end

    def row_error(title, options, correct)
      return I18n.t('imports.errors.missing_title') if title.blank?
      return I18n.t('imports.errors.blank_option') if options.any?(&:blank?)
      return I18n.t('imports.errors.too_few_options') if options.size < 2
      return I18n.t('imports.errors.too_many_options') if options.size > OPTION_HEADERS.size
      return I18n.t('imports.errors.missing_correct') if correct.blank?

      correct_error(options, correct)
    end

    def correct_error(options, correct)
      letter = correct.upcase
      index = letter_index(letter)

      if index.nil?
        I18n.t('imports.errors.invalid_correct', value: correct)
      elsif index >= options.size
        I18n.t('imports.errors.correct_out_of_range', letter:, count: options.size)
      end
    end

    def letter_index(letter)
      return nil unless letter.match?(/\A[A-E]\z/)

      letter.ord - 'A'.ord
    end

    def normalize(cell)
      stringify(cell).downcase
    end

    def stringify(cell)
      case cell
      when nil then ''
      when Float then cell == cell.to_i ? cell.to_i.to_s : cell.to_s
      else cell.to_s.strip
      end
    end
  end
end
