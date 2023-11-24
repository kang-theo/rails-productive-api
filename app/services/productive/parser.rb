# frozen_string_literal: true

module Productive
  module Parser
    def self.handle_response(response, klass)
      # exception handling
      raise ApiRequestError, "API request failed with status #{response.code}: #{response.body}" unless response.success?
      
      begin
        parsed_data = JSON.parse(response.body)['data']
      rescue JSON::ParserError => e
        Rails.logger.error "JSON::ParserError: #{e.message}"
        render json: { error: 'JSON::ParserError' }, status: :bad_response
      end

      flatten_data = parsed_data.is_a?(Array) ? parsed_data : [parsed_data]

      entities = flatten_data.map do |data_hash|
        # parse entity attributes
        attributes = data_hash['attributes'].merge(id: data_hash['id'])

        relationships_hash = data_hash['relationships']
        relationships_hash.each do |key, value|
          data = value["data"]
          next if data.blank?

          if data.is_a?(Array)
            attributes["#{key.singularize}_ids"] = data.map { |data| data["id"] }
          else
            attributes["#{key.singularize}_id"] = data["id"]
          end
        end
      
        # parse association_types
        association_types = relationships_hash.keys

        # create instances
        klass.new(attributes, association_types)
      end

      entities
    end
  end
end
