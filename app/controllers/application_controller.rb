class ApplicationController < ActionController::Base
  rescue_from ProductiveClientException, with: :handle_productive_client_exception

  def handle_productive_client_exception(exception)
    logger.error "ProductiveClientException: #{exception.message}"
    render json: {error: "Productive Client Error"}, status: :bad_request
  end

end
