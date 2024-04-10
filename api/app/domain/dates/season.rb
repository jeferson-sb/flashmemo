# frozen_string_literal: true

module Dates
  class Season
    class << self
      QUARTERS = { 1 => 0.25, 2 => 0.50, 3 => 0.75 }.freeze

      def from(date, hemisphere = :north)
        day_of_year = date.yday
        length = Date.leap?(date.year) ? 366 : 365

        case hemisphere
        when :north
          case day_of_year
          when 1..(length * QUARTERS[1]).floor
            :winter
          when (length * QUARTERS[1]).floor + 1..(length * QUARTERS[2]).floor
            :spring
          when (length * QUARTERS[2]).floor + 1..(length * QUARTERS[3]).floor
            :summer
          else
            :autumn
          end
        when :south
          case day_of_year
          when 1..(length * QUARTERS[1]).floor
            :summer
          when (length * QUARTERS[1]).floor + 1..(length * QUARTERS[2]).floor
            :autumn
          when (length * QUARTERS[2]).floor + 1..(length * QUARTERS[3]).floor
            :winter
          else
            :spring
          end
        else
          raise ArgumentError, 'Invalid hemisphere'
        end
      end
    end
  end
end
