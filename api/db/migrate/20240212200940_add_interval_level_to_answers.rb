# frozen_string_literal: true

class AddIntervalLevelToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :interval_level, :integer, default: 0
  end
end
