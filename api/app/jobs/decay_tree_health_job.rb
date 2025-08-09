# frozen_string_literal: true

class DecayTreeHealthJob < ApplicationJob
  DECAY_VALUE = 1

  def perform
    Tree.find_each do |tree|
      return unless tree.health != 0

      tree.health -= DECAY_VALUE
      tree.save!
    end
  end
end
