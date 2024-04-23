# frozen_string_literal: true

module Gardener
  class Plant
    class << self
      def perform(garden, name)
        raise 'Not enough seeds' if garden.seeds <= 0

        tree = garden.trees.new(name:, phase: :seed)
        tree.validate!
        garden.seeds -= 1
        garden.save!
      end
    end
  end
end
