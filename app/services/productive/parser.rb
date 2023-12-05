# frozen_string_literal: true

module Productive
  module Parser
    def self.handle_response(response, klass)
      return [] unless response.success?
      
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
        { error: 'JSON::ParserError', status: :bad_response }
      end
    end

    # Parses associations from a hash.
    #
    # Input:
    #   {"id"=>"xxx", "attributes"=>{"name"=>"xxx", "relationships"=>{"organization"=>{"data"=>{"type"=>"organizations", "id"=>"xxx"}}}}}
    #
    # @param [Hash] data_hash: The hash containing association information.
    # @return [Hash] Parsed association information.
    def self.parse_associations_info(data_hash)
      association_info = {}

      relationships = data_hash['relationships']
      relationships.each do |key, value|
        data = value["data"]
        next if data.blank?

        # flatten_data = data.is_a?(Array) ? data : [data]
        # association_info[key] = flatten_data.map { |flatten_data| flatten_data["id"] }
        association_info[key] = data.is_a?(Array) ? data.map { |datum| datum["id"] } : data["id"]
      end

      association_info
    end

    # Parses attributes from a hash, considering association information.
    #
    # Example Input:
    #   data_hash: {"id"=>"xxx", "attributes"=>{"name"=>"xxx", "relationships"=>{"organization"=>{"data"=>{"type"=>"organizations", "id"=>"xxx"}}}}}
    #   association_info: {"organization"=>["xxx"], "company"=>["xxx"], "workflow"=>["xxx"], "memberships"=>["xxx", "xxx"]}
    #
    # @param [Hash] data_hash: The hash containing attribute and relationship information.
    # @param [Hash] association_info: The hash containing association information.
    # @return [Hash] Parsed attributes.
    def self.parse_attributes(data_hash, association_info)
      attributes = data_hash['attributes'].merge("id" => data_hash['id'])

      association_info.each do |key, value|
        association_key = "#{key.singularize}_id#{'s' if value.is_a?(Array)}"
        attributes.merge!(association_key => value)
      end

      attributes
    end
  end
end