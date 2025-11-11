class CreateShortUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :short_urls do |t|
      t.text :original_url, null: false
      t.string :short_code, null: false
      t.datetime :deactivated_at
      t.integer :clicks_count, null: false, default: 0
      t.timestamps
    end
  end
end
