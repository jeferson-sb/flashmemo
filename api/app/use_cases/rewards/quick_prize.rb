# frozen_string_literal: true

module Rewards
  class QuickPrize
    class << self
      def draw(distributor)
        seeds = rand(1..20)
        distributor.earn(seeds, 0)
        seeds
      end
    end
  end
end
