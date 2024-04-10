# frozen_string_literal: true

module Gardener
  class Nurture
    class << self
      def perform(tree_id, nutrients)
        tree = Tree.find(tree_id)
        
        if tree.health + nutrients <= 100
          tree.health += nutrients
          tree.save!
        end
      end
    end
  end
end
