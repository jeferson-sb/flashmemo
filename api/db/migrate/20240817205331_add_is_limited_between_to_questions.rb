# frozen_string_literal: true

class AddIsLimitedBetweenToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :is_limited_between, :daterange
  end
end
