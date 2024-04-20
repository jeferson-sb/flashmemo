# frozen_string_literal: true

module Gardener
  class Nurture
    class << self
      def perform(tree, nutrients)
        return unless tree.health + nutrients <= 100

        tree.health += nutrients
        tree.save!
      end
    end
  end
end
