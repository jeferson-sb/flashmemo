# frozen_string_literal: true

class RemoveQuestionFromAnswers < ActiveRecord::Migration[7.0]
  def change
    remove_column :answers, :text, :string
    remove_column :answers, :question_id
  end
end
