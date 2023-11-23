class ApplicationController < ActionController::Base
  rescue_from ApiRequestError, with: :handle_api_request_exception
  rescue_from ApiResponseError, with: :handle_api_response_exception

  def handle_api_request_exception(exception)
    logger.error "APIRequestError: #{exception.message}"
    render json: { error: 'API Request Error' }, status: :bad_request
  end

  def handle_api_response_exception(exception)
    logger.error "APIResponseError: #{exception.message}"
    render json: { error: 'API Response Error' }, status: :bad_response
  end
end
