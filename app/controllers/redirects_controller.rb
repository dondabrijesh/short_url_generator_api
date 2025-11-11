class RedirectsController < ApplicationController
  def show
    nil unless validate_params(:code)
    url = Url::Service.new(short_url_code: params[:code])
    original_url = url.get_original_url
    redirect_to original_url, status: :found, allow_other_host: true
  rescue ActiveRecord::RecordNotFound => e
    render_not_found(e)
  end
end
