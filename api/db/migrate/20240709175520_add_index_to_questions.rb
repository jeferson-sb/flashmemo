# frozen_string_literal: true

class AddIndexToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_index :questions, :id
    add_index :exams, :id
  end
end
