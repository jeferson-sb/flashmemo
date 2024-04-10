# frozen_string_literal: true

module Rewards
  class Compensation
    def initialize
      @seeds = 0
      @nutrients = 0
    end

    def rules(data)
      return [@seeds, @nutrients] unless valid_score?(data[:score])

      if first_interaction?(data[:answers])
        @seeds += 1
      elsif twenth_tree?(data[:trees])
        @seeds += 3
      elsif high_score?(data[:score])
        @seeds += 2
        @nutrients = 1
      end

      case Dates::Season.from(Time.now, :south)
      when :summer
        summer(data[:is_new_topic])
      when :autumn
        autumn(data[:is_new_topic], data[:is_review])
      when :winter
        winter(data[:is_review])
      else
        spring(data[:is_new_topic])
      end

      [@seeds, @nutrients]
    end

    private

    def valid_score?(score)
      (score > 10)
    end

    def first_interaction?(answers)
      answers <= 0
    end

    def twenth_tree?(trees)
      (trees + 1) == 20
    end

    def high_score?(score)
      (score > 90)
    end

    def winter(is_review)
      return unless is_review

      @seeds += 1
      @nutrients += 3
    end

    def summer(is_new_topic)
      return unless is_new_topic

      @seeds += 1
      @nutrients += 4
    end

    def spring(is_new_topic)
      return unless is_new_topic

      @seeds += 3
      @nutrients += 1
    end

    def autumn(is_new_topic, is_review)
      return unless is_new_topic || is_review

      @seeds += 3
      @nutrients += 1
    end
  end
end
