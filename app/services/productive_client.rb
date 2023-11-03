# require 'active_support/core_ext/hash'
class ProductiveClient
  include HTTParty
  base_uri 'https://api.productive.io/api/v2'

  def initialize()
    # api_key = "c664831b-4419-4bb0-9dc0-09816f04cea2"
    # org_id = "30958"
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
      # debugger
      # puts parsed_data
      r = Project.new(parsed_data)
      puts r.to_s
      # debugger
    else
      raise "API request failed with status #{response.code}: #{response.body}"
    end
  end

  def process_request(endpoint = "")
    response = self.class.get("/#{pluralized_resource_name()}/#{endpoint}", headers: @headers)
    handle_response(response)
  end

  def pluralized_resource_name()
    self.class.name.split(/(?=[:A-Z])/).first.downcase().pluralize()
  end

end