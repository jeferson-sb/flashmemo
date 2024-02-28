class AddLastAttemptedToAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :answers, :last_attempted_at, :datetime
  end
end
