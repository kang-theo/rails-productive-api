class HttpClient
  include HTTParty
  # base_uri @endpoint
  base_uri "https://api.productive.io/api/v2"

  def initialize(endpoint, auth_info)
    raise ApiRequestError, "Invalid endpoint" unless endpoint.is_a?(String)
    raise ApiRequestError, "Invalid Token" unless auth_info.is_a?(Hash)

    @endpoint = endpoint
    @headers  = auth_info
  end

  def get(req_params)
    Rails.logger.info("HTTP Request: #{self.class.default_options[:base_uri]}/#{req_params}")

    self.class.get("#{self.class.default_options[:base_uri]}/#{req_params}", headers: @headers)
  end

  # def post(uri, data)
  #   @options[:body] = data.to_json
  #   self.class.post(uri, @options)
  # end

  # def put(uri, data)
  #   @options[:body] = data.to_json
  #   self.class.put(uri, @options)
  # end

  # def delete(uri)
  #   self.class.delete(uri, @options)
  # end
end