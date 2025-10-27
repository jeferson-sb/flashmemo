class AddProfile < ActiveRecord::Migration[8.0]
  def change
    enable_extension "hstore" unless extension_enabled?("hstore")
    create_table :profiles do |t|
      t.hstore "settings"
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
