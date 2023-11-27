# frozen_string_literal: true

module Productive
  module Parser
    def self.handle_response(response, klass)
      # exception handling
      raise ApiRequestError, "API request failed with status #{response.code}: #{response.body}" unless response.success?
      
      parsed_data = parse_response { JSON.parse(response.body).dig('data') }
      flatten_data = parsed_data.is_a?(Array) ? parsed_data : [parsed_data]

      entities = flatten_data.map do |data_hash|
        association_info = parse_associations_info(data_hash)
        attributes = parse_attributes(data_hash, association_info)

        # create instances
        klass.new(attributes, association_info)
      end

      entities
    end

    private

    def self.parse_response
      begin
        yield
      rescue JSON::ParserError => e
        Rails.logger.error "JSON::ParserError: #{e.message}"
        render json: { error: 'JSON::ParserError' }, status: :bad_response
      end
    end

    # dash_hash: {"id"=>"xxx", 
    #             "attributes"=>{"name"=>"xxx", 
    #             "relationships"=>{"organization"=>{"data"=>{"type"=>"organizations", "id"=>"xxx"}}}}}
    def self.parse_associations_info(data_hash)
      association_info = {}

      relationships = data_hash['relationships']
      relationships.each do |key, value|
        data = value["data"]
        next if data.blank?

        flatten_data = data.is_a?(Array) ? data : [data]
        association_info[key] = flatten_data.map { |flatten_data| flatten_data["id"] }
      end

      association_info
    end

    # association_info: {"organization"=>["xxx"], "company"=>["xxx"], "workflow"=>["xxx"], "memberships"=>["xxx", "xxx"]}
    def self.parse_attributes(data_hash, association_info)
      attributes = data_hash['attributes'].merge(id: data_hash['id'])

      association_info.each do |key, value|
        if value.is_a?(Array) 
          attributes["#{key.singularize}_ids"] = value
        else
          attributes["#{key.singularize}_id"] = value
        end
      end

      attributes
    end
  end
end