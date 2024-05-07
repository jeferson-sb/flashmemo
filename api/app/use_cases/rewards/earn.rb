# frozen_string_literal: true

module Rewards
  class Earn
    class << self
      def perform(last_answer, user, revision = false)
        has_new_answer_today = last_answer.created_at >= Time.zone.now.beginning_of_day      
        return unless last_answer.last_attempted_over_a_day? && user.garden.present?

        compensator = Rewards::Compensation.new
        seeds, nutrients = compensator.rules({
                                               score: last_answer.score,
                                               answers: user.answer.length,
                                               trees: user.garden.trees.length,
                                               is_new_topic: has_new_answer_today,
                                               is_review: revision
                                             })

        distributor = Rewards::Distribute.new(user.garden.id)
        distributor.earn(user.garden, seeds, nutrients)
      end
    end
  end
end
