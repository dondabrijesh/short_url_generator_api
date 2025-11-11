class AddIndexOnShortUrlAndClick < ActiveRecord::Migration[8.0]
  def change
    add_index :short_urls, :short_code, unique: true
    add_index :short_urls, [ :original_url ], unique: true, where: "deactivated_at IS NULL", name: "idx_unique_active_original_url"
  end
end
