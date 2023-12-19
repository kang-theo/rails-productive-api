# frozen_string_literal: true

module Productive
  module Parser
    def self.handle_response(response, entity_class)
      # refactor: replace method with method object
      ResponseHandler.new(self, response, entity_class).compute
    end
  end

  # refactor: replace method with method object
  class ResponseHandler
    attr_accessor :parser, :response, :entity_class, :attributes, :association_info

    def initialize(parser, response, entity_class)
      @parser = parser
      @response = response
      @entity_class =entity_class 

      @attributes = {}
      @association_info = {}
    end

    def compute
      return [] unless response.code == 200

      parsed_data = response.body.dig('data')
      flatten_data = parsed_data.is_a?(Array) ? parsed_data : [parsed_data]

      klass = entity_class.class != Class ? entity_class.class : entity_class 

      entities = flatten_data.map do |data_hash|
        parse_associations_info(data_hash)
        parse_attributes(data_hash)

        # create instances
        klass.new(attributes, association_info)
      end

      entities
    end

    private

    # Parses associations from a hash.
    #
    # Input:
    #   {"id"=>"xxx", "attributes"=>{"name"=>"xxx", "relationships"=>{"organization"=>{"data"=>{"type"=>"organizations", "id"=>"xxx"}}}}}
    #
    # @param [Hash] data_hash: The hash containing association information.
    # @return [Hash] Parsed association information.
    def parse_associations_info(data_hash)
      relationships = data_hash['relationships']
      relationships.each do |key, value|
        data = value['data']
        next if data.blank?

        # flatten_data = data.is_a?(Array) ? data : [data]
        # association_info[key] = flatten_data.map { |flatten_data| flatten_data["id"] }
        association_info[key] = data.is_a?(Array) ? data.map { |datum| datum['id'] } : data['id']
      end
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
    def parse_attributes(data_hash)
      attributes.merge!(data_hash['attributes'].merge('id' => data_hash['id']))

      association_info.each do |key, value|
        association_key = "#{key.singularize}_id#{'s' if value.is_a?(Array)}"
        attributes.merge!(association_key => value)
      end
    end

  end
end
