# frozen_string_literal: true

module Gardener
  class Plant
    class << self
      def perform(garden_id, name)
        garden = Garden.find(garden_id)

        return unless garden.seeds > 0

        garden.trees.new(name:, phase: :seed)
        garden.seeds -= 1
        garden.save!
      end
    end
  end
end
