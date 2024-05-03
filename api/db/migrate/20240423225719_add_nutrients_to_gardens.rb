# frozen_string_literal: true

class AddNutrientsToGardens < ActiveRecord::Migration[7.0]
  def change
    add_column :gardens, :nutrients, :integer, default: 0
  end
end
