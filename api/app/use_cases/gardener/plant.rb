# frozen_string_literal: true

module Gardener
  class Plant
    class << self
      def perform(garden, name)
        raise 'Not enough seeds' if garden.seeds.positive?

        garden.trees.new(name:, phase: :seed)
        garden.seeds -= 1
      end
    end
  end
end
