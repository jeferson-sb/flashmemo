# frozen_string_literal: true

class AddAssociationToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :score, :integer

    add_reference :answers, :user, foreign_key: true
    add_reference :answers, :exam, foreign_key: true
  end
end
