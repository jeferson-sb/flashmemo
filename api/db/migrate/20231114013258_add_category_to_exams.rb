class AddCategoryToExams < ActiveRecord::Migration[7.0]
  def change
    add_reference :exams, :category, foreign_key: true
  end
end
