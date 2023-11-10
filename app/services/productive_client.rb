# frozen_string_literal: true

class ProductiveClient
  include HTTParty
  base_uri 'https://api.productive.io/api/v2'

  attr_accessor :entity

  def initialize(entity = '')
    @entity = entity
    @headers = {
      "X-Auth-Token": Rails.application.credentials.productive_api_token,
      "X-Organization-Id": Rails.application.credentials.organization_id.to_s,
      "Content-Type": 'application/vnd.api+json'
    }
  end

  def get(options = {})
    uri = "/#{entity}"
    uri += "/#{options[:id]}" if options.key?(:id)

    Rails.logger.info("HTTP Request: #{self.class.default_options[:base_uri]}#{uri}")

    response = self.class.get(uri, headers: @headers)
    handle_response(response)
  end

  def handle_response(response)
    if !response.success? || response.body.blank?
      raise ApiRequestError, "API request failed with status #{response.code}: #{response.body}"
    end

    parsed_data = JSON.parse(response.body)['data']
    entity_result = []

    raise ApiRequestError, 'Entity is nil' if entity.nil?

    # "projects" -> "Project"
    entity_name = entity.singularize.capitalize

    if parsed_data.is_a?(Array)
      parsed_data.map { |item| entity_result.push(Object.const_get(entity_name).new(item)) }
    else
      # debugger
      entity_result.push(Object.const_get(entity_name).new(parsed_data))
    end
    entity_result
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
