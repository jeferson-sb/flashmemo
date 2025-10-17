class AddTokenToSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :sessions, :token, :string
    add_index :sessions, :token, unique: true
  end
end
