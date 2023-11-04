require 'logutils'

class ProductiveClient
  include LogUtils::Logging
  include HTTParty
  base_uri 'https://api.productive.io/api/v2'

  def initialize()
    @headers = {
      "X-Auth-Token" => Rails.application.credentials.productive_api_token,
      "X-Organization-Id" => Rails.application.credentials.organization_id.to_s,
      "Content-Type" => "application/vnd.api+json"
    }
  end

  def all()
    process_request()
  end

  def find(id)
    process_request(id)
  end

  private

  def handle_response(response)
    if response.success? && !response.body.blank?
      parsed_data = JSON.parse(response.body)["data"]
      project_result = Array.new()

      if parsed_data.is_a?(Array)
        parsed_data.map {|item| project_result.push(Project.new(item))}
      elsif
        project_result.push(Project.new(parsed_data))
      end
      return project_result
    else
      raise "API request failed with status #{response.code}: #{response.body}"
    end
  end

  def process_request(endpoint = "")
    logger.info("Http Request: #{self.class.default_options[:base_uri]}/#{pluralized_resource_name()}/#{endpoint}")
    response = self.class.get("/#{pluralized_resource_name()}/#{endpoint}", headers: @headers)
    handle_response(response)
  end

  def pluralized_resource_name()
    self.class.name.split(/(?=[:A-Z])/).first.downcase().pluralize()
  end

end