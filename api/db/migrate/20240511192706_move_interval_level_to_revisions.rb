# frozen_string_literal: true

class MoveIntervalLevelToRevisions < ActiveRecord::Migration[7.0]
  def change
    remove_column :answers, :interval_level
    add_column :revisions, :interval_level, :integer, default: 0
  end
end
