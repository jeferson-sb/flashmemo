# frozen_string_literal: true

require 'tzinfo'

module Dates
  class Season
    class << self
      QUARTERS = { 1 => 0.25, 2 => 0.50, 3 => 0.75, 4 => 1.0 }.freeze
      SEASONS = {
        winter: { north: 1, south: 3 },
        spring: { north: 2, south: 4 },
        summer: { north: 3, south: 1 },
        autumn: { north: 4, south: 2 }
      }.freeze

      def from(date, hemisphere = :north)
        validate_hemisphere(hemisphere)

        day_of_year = date.yday
        length = Date.leap?(date.year) ? 366 : 365
        quarter = calculate_quarter(day_of_year, length)

        season = SEASONS.find { |_, v| v[hemisphere] == quarter }
        season ? season.first : raise("Season not found for hemisphere: #{hemisphere}, quarter: #{quarter}")
      end

      def hemisphere_from_country(country_name)
        c = TZInfo::Country.get(country_name)
        lat = c.zone_info.first.latitude
        if lat.nil?
          :unknown
        elsif lat > 0
          :north
        elsif lat < 0
          :south
        else
          :equator
        end
      end

      private

      def calculate_quarter(day_of_year, length)
        QUARTERS.each do |quarter, multiplier|
          return quarter if day_of_year <= (length * multiplier).floor
        end
      end

      def validate_hemisphere(hemisphere)
        raise ArgumentError, 'Invalid hemisphere' unless %i[north south].include?(hemisphere)
      end
    end
  end
end
