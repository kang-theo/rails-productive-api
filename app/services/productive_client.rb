class ProductiveClient
  include HTTParty
  base_uri 'https://api.productive.io/api/v2'

  attr_accessor :entity

  def initialize(entity = "")
    @entity = entity
    @headers = {
      "X-Auth-Token": Rails.application.credentials.productive_api_token,
      "X-Organization-Id": Rails.application.credentials.organization_id.to_s,
      "Content-Type": "application/vnd.api+json"
    }
  end

  # options: {entity: "", id: nil, action: "", data: {}}, hash.default
  def all
    raise ProductiveClientException, "Entity is nil" if entity.nil? 
    get(Hash[entity: entity])
  end

  def find(id)
    raise ProductiveClientException, "Entity or Id is nil" if entity.nil? || id.nil?
    process_request(Hash[entity: entity, id: id])
  end

  private

  def get(options)
    uri = "/#{options[:entity]}"
    uri += "/#{options[:id]}" if options[:id]

    Rails.logger.info("HTTP Request: #{self.class.default_options[:base_uri]}#{uri}")

    response = self.class.get(uri, headers: @headers)
    handle_response(response)
  end

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