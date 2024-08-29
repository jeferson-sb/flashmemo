# frozen_string_literal: true

module Rewards
  class Distribute
    def initialize(garden)
      @garden = garden
    end

    def earn(seeds, nutrients)
      @garden.seeds += seeds
      @garden.nutrients += nutrients
      @garden.save!
    end
  end
end
