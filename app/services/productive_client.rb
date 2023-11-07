class ProductiveClient
  include HTTParty
  base_uri 'https://api.productive.io/api/v2'

  def initialize
    @headers = {
      "X-Auth-Token": Rails.application.credentials.productive_api_token,
      "X-Organization-Id": Rails.application.credentials.organization_id.to_s,
      "Content-Type": "application/vnd.api+json"
    }
  end

  def all
    process_request({})
  end

  def find(id)
    process_request({id: id})
  end

  private

  def handle_response(response)
    if !response.success? || response.body.blank?
      raise "API request failed with status #{response.code}: #{response.body}"
    end

    parsed_data = JSON.parse(response.body)["data"]
    project_result = Array.new()

    if parsed_data.is_a?(Array)
      parsed_data.map {|item| project_result.push(Project.new(item))}
    else
      project_result.push(Project.new(parsed_data))
    end
    project_result
  end

  def process_request(options)
    Rails.logger.info("HTTP Request: #{self.class.default_options[:base_uri]}/#{pluralized_resource_name()}/#{options[:id]}")

    response = self.class.get("/#{pluralized_resource_name()}/#{options[:id]}", headers: @headers)
    handle_response(response)
  end

  def pluralized_resource_name
    request_module = self.class.name.split("Client")

    if request_module.nil?
      raise ProductiveClientException, "Request module not found"
    end

    request_module.first.downcase().pluralize()
  end

end