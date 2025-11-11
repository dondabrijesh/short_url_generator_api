class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable

  private

  def render_not_found(err)
    render json: { error: { code: "not_found", message: err.message } }, status: :not_found
  end

  def render_unprocessable(err)
    render json: { error: { code: "invalid_record", message: err.record.errors.full_messages.to_sentence } }, status: :unprocessable_entity
  end

  def render_success(data = {}, message = "Success", status = :ok)
      render json: { data: data, message: message }, status: status
  end

  def render_failure(data = {}, message = "Failure", status = :internal_server_error)
    render json: { data: data, message: message }, status: status and return
  end

  def render_conflict(message)
    render json: { error: { code: "conflict", message: message } }, status: :conflict
  end

  def validate_params(*keys)
    missing_keys = keys.select { |key| !params.key?(key.to_s) }

    if missing_keys.present?
      render json: { message: "Parameters Misssing: #{missing_keys.join(", ")}" }, status: :bad_request
      return false
    end

    true
  end
end
