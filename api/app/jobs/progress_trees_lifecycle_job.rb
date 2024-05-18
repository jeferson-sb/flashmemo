# frozen_string_literal: true

class ProgressTreesLifecycleJob < ApplicationJob
  queue_as :default

  CYCLE = {
    seed: 3,
    growing: 10,
    mature: 30,
    fall: 90
  }.freeze

  def perform
    Tree.find_each do |tree|
      life_start = tree.created_at
      days_age = (Date.today - life_start.to_date).to_i

      tree.phase = grow_up(days_age)
      tree.save!
    end
  end

  private

  def grow_up(days)
    if days < CYCLE[:seed]
      :seed
    elsif days < CYCLE[:mature]
      :growing
    elsif days < CYCLE[:fall]
      :mature
    else
      :fall
    end
  end
end
