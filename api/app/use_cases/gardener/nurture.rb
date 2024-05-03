# frozen_string_literal: true

module Gardener
  class Nurture
    class << self
      def perform(tree, garden, nutrients)
        raise 'Not enough nutrients' if insufficient_nutrients?(garden, nutrients)
        raise 'Nutrients should be greater than 1' if negative_nutrients?(nutrients)
        raise 'Tree health should be lower than 100' if tree_health_full?(tree)
        raise 'Cannot use more nutrients than 100' if exceeded_nutrients_limit?(tree, nutrients)

        update_tree_health(tree, nutrients)
        update_garden_nutrients(garden)
      end

      private

      def update_tree_health(tree, nutrients)
        tree.health += nutrients
        tree.save!
      end

      def update_garden_nutrients(garden)
        garden.nutrients -= 1
        garden.save!
      end

      def insufficient_nutrients?(garden, nutrients)
        garden.nutrients.negative? || garden.nutrients < nutrients
      end

      def negative_nutrients?(nutrients)
        nutrients <= 0
      end

      def tree_health_full?(tree)
        tree.health == 100
      end

      def exceeded_nutrients_limit?(tree, nutrients)
        tree.health + nutrients > 100
      end
    end
  end
end
