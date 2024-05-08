# frozen_string_literal: true

module Rewards
  class Earn
    class << self
      def perform(last_answer, user, revision = false)
        is_first_answer_attempt = last_answer.new_answer?
        return unless (last_answer.last_attempted_over_a_day? || is_first_answer_attempt) && user.garden.present?

        compensator = Rewards::Compensation.new
        seeds, nutrients = compensator.rules({
                                               score: last_answer.score,
                                               answers: user.answer.length,
                                               trees: user.garden.trees.length,
                                               is_new_topic: is_first_answer_attempt,
                                               is_review: revision
                                             })

        distributor = Rewards::Distribute.new(user.garden.id)
        distributor.earn(user.garden, seeds, nutrients)
      end
    end
  end
end
