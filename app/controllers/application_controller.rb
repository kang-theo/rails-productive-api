class ApplicationController < ActionController::Base
  rescue_from ApiRequestError, with: :handle_api_request_exception

  def handle_api_request_exception(exception)
    logger.error "APIRequestError: #{exception.message}"
    render json: { error: 'API Request Error' }, status: :bad_request
  end
end
