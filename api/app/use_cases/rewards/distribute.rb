# frozen_string_literal: true

module Rewards
  class Distribute
    def initialize(garden_id)
      @garden_id = garden_id
    end

    def earn(seeds, nutrients)
      garden = Garden.find(@garden_id)
      garden.seeds += seeds
      garden.save!
    end
  end
end
