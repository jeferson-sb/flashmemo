# frozen_string_literal: true

module Answers
  class InRange
    class << self
      MONTH = { january: 1, june: 6, july: 7, december: 12 }.freeze

      def perform(user_id, period)
        start_date, end_date = get_dates(period)

        Answer.where(user_id:, created_at: start_date..end_date)
      end

      private

      def get_semester_dates(date)
        if date.month >= MONTH[:july]
          [Date.new(date.year, MONTH[:january]).beginning_of_month, Date.new(date.year, MONTH[:june]).end_of_month]
        else
          [Date.new(1.year.ago.year, MONTH[:july]).beginning_of_month,
           Date.new(1.year.ago.year, MONTH[:december]).end_of_month]
        end
      end

      def get_dates(period)
        current_date = Time.now

        case period
        when 'monthly'
          [30.days.ago, nil]
        when 'yearly'
          [1.year.ago, nil]
        when 'semester'
          get_semester_dates(current_date)
        else
          [nil, nil]
        end
      end
    end
  end
end
