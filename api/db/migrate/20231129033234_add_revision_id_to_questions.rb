# frozen_string_literal: true

class AddRevisionIdToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_reference :questions, :revision, foreign_key: true
  end
end
