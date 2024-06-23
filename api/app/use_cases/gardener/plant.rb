# frozen_string_literal: true

module Gardener
  class Plant
    class << self
      def perform(garden, name)
        raise 'Not enough seeds' if insufficient_seeds?(garden)

        create_tree(garden, name)
        consume_seed(garden)
      end

      private

      def insufficient_seeds?(garden)
        garden.seeds <= 0
      end

      def create_tree(garden, name)
        tree = garden.trees.new(name:, phase: :seed)
        tree.validate!
      end

      def consume_seed(garden)
        garden.seeds -= 1
        garden.save!
      end
    end
  end
end
