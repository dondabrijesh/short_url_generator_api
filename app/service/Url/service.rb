# app/services/url/service.rb
module Url
  class Service
    def initialize(original_url: nil, short_url_code: nil)
      @urls = Array.wrap(original_url)
      @short_url_code = short_url_code
      @results = []
      Rails.logger.error("[Url::Service] Urls: #{@urls}, Short URL Code: #{@short_url_code}")
    end

    def create_short_url
      @urls.each do |url|
        handle_url_creation(url)
      end

      @results
    end

    def get_original_url
      short_url = ShortUrl.active.find_by(short_code: @short_url_code)
      raise ActiveRecord::RecordNotFound, "Short URL not found or deactivated" unless short_url

      short_url.clicks.create!(clicked_at: Time.current)

      short_url.increment!(:clicks_count)

      short_url.original_url
    end

    def deactivate_short_url
      short_url = ShortUrl.active.find_by(short_code: @short_url_code)
      raise ActiveRecord::RecordNotFound, "Short URL not found or already deactivated" unless short_url

      short_url.deactivate!
    end

    private

    def handle_url_creation(url)
      existing = ShortUrl.active.find_by(original_url: url)

      if existing
        @results << {
          original_url: url,
          short_url: existing.url,
          error: "URL already shortened and active"
        }
        return
      end

      create_new_short_url(url)
    end

    def create_new_short_url(url)
      ActiveRecord::Base.transaction do
        short_url = ShortUrl.new(original_url: url)

        if short_url.save
          @results << {
            original_url: url,
            short_url: short_url.url
          }
        else
          @results << {
            original_url: url,
            error: short_url.errors.full_messages.to_sentence
          }
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("[Url::Service] Create Service:RecordInvalid: Unexpected error for URL #{url}: #{e.message}")
      @results << { original_url: url, error: e.message }
    rescue StandardError => e
      Rails.logger.error("[Url::Service] Create Service: Unexpected error for URL #{url}: #{e.message}")
      @results << { original_url: url, error: "Unexpected error: #{e.message}" }
    end
  end
end
