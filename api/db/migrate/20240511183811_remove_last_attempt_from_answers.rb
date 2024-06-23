# frozen_string_literal: true

class RemoveLastAttemptFromAnswers < ActiveRecord::Migration[7.0]
  def change
    remove_column :answers, :last_attempted_at
  end
end
