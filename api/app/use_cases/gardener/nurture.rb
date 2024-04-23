# frozen_string_literal: true

module Gardener
  class Nurture
    class << self
      def perform(tree, garden, nutrients)
        raise 'Not enough nutrients' if garden.nutrients < 0 || garden.nutrients < nutrients
        raise 'Nutrients should be greater than 1' if nutrients <= 0
        raise 'Tree health should be lower than 100' if tree.health == 100
        raise 'Cannot use more nutrients than 100' if tree.health + nutrients > 100

        tree.health += nutrients
        tree.save!
    
        garden.nutrients -= 1
        garden.save!
      end
    end
  end
end
