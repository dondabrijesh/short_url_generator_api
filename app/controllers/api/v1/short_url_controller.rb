module Api
  module V1
    class ShortUrlController < ApplicationController
      def create
        return unless validate_params(:urls)
        begin
          url = Url::Service.new(original_url: params[:urls])
          result = url.create_short_url()
          render_success result, "Sucess!!", :created and return
        rescue => error
          Rails.logger.error("Something went wrong: #{error.message}")
          render_failure error.message and return
        end
      end

      def deactivate
        return unless validate_params(:short_code)
        begin
          Url::Service.new(short_url_code: params[:short_code]).deactivate_short_url
          render_success nil, "Short URL deactivated successfully", :ok and return
        rescue =>e
          render_failure e.message and return
        end
      end

      def analytics
        # return unless validate_params(:start_date, :end_date)
        begin
          result = Url::AnalyticsService.new(params[:start_date], params[:end_date], params[:timezone]).call
          render_success result, "Analytics fetched successfully", :ok and return
        rescue => e
          render_failure e.message and return
        end
      end
    end
  end
end
