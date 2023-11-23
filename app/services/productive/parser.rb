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

      instance_results = []
      flatten_data = parsed_data.is_a?(Array) ? parsed_data : [parsed_data]

      flatten_data.each do |data_hash|
        # parse entity attributes and association_types
        attributes = data_hash['attributes'].merge(id: data_hash['id'])
        association_types = []

        data_hash['relationships'].each do |key, value|
          association_types.push(key)

          data = value["data"]
          next if data.blank?

          if data.is_a?(Array)
            ids = data.map do |data| 
              data["id"] 
            end

            attributes["#{key.singularize}_ids"] = ids
          else
            attributes["#{key.singularize}_id"] = data["id"]
          end
        end
      
        # create instances
        entity = klass.new(attributes, association_types)
        instance_results.push(entity)
      end

      instance_results
    end

    private

  end
end
