class CreateClicks < ActiveRecord::Migration[8.0]
  def change
    create_table :clicks do |t|
      t.references :short_url, null: false, foreign_key: true
      t.datetime :clicked_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.timestamps
    end
  end
end
