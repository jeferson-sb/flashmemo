# frozen_string_literal: true

class AddHasDuoToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :has_duo, :boolean, default: false
  end
end
