module Url
  class AnalyticsService
    def initialize(start_date, end_date, timezone = "UTC")
      @timezone = Utils.new(timezone).timezone_parser
      @start_time = @timezone.parse(start_date)&.beginning_of_day&.utc
      @end_time = @timezone.parse(end_date)&.end_of_day&.utc
      Rails.logger.info "UTC range: TimeZone:#{@timezone.name} #{@start_time} → #{@end_time}"
    end

    def call
      analytics_data = ShortUrl.includes(:clicks).map do |url|
        clicks = filter_clicks(url.clicks)
        {
          is_active: url.active?,
          original_url: url.original_url,
          short_code: url.url,
          short_url: url.url,
          total_clicks_count: url.clicks.size,
          filtered_clicks_count: clicks.size,
          created_at: url.created_at
        }
      end
      analytics_data
    rescue => e
      Rails.logger.error("[AnalyticsService] Error: #{e.message}")
      raise e
    end

    private

    def filter_clicks(clicks)
      clicks = clicks.where("clicked_at >= ?", @start_time) if @start_time.present?
      clicks = clicks.where("clicked_at <= ?", @end_time) if @end_time.present?
      Rails.logger.error("[AnalyticsService] Filtered Clicks count: #{clicks.size}")
      clicks
    end
  end
end
