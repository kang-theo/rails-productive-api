# frozen_string_literal: true

module Productive
  module Parser
    @@instance_attrs = {}
    @@foreign_key_types = []
    @@instane_class = nil
    
    def self.instance_attrs
      @@instance_attrs
    end
    
    def self.foreign_key_types
      @@foreign_key_types
    end

    # base: the class that includes this module
    def self.included base
      @@instance_class = base
    end

    def self.instance_class
      @@instance_class
    end

    def self.handle_response(response)
      raise ApiRequestError, "API request failed with status #{response.code}: #{response.body}" unless response.success?
      raise ApiRequestError, "API response is blank" if response.body.blank?
        
      parsed_data = JSON.parse(response.body)['data']
      instance_results = []

      flatten_data = parsed_data.is_a?(Array) ? parsed_data : [parsed_data]
      flatten_data.each do |datum|
        parse_attributes_and_types(datum)

        # creating instances
        entity = instance_class.new(instance_attrs, foreign_key_types)
        instance_results.push(entity)
      end
      instance_results
    end

    private

    def self.parse_attributes_and_types(data)
      instance_attrs.clear
      foreign_key_types.clear

      instance_attrs[:id] = data['id']
      instance_attrs.merge!(data['attributes'])

      data['relationships'].each do |_key, value|
        next unless value.is_a?(Hash)

        data = value['data']
        next if data.blank?

        flatten_data = data.is_a?(Array) ? data : [data]
        next if flatten_data.empty? || flatten_data.first.blank?

        # eg. "memberships_id": ["6104455", "6104456", "6104457", "6104464"]
        #     "project_manager": {"data"=>{"type"=>"people", "id"=>"412034"}}
        type = flatten_data.first['type']
        foreign_key_types.push(type)

        instance_attrs[(type.singularize + '_id').to_sym] = flatten_data.map do |datum|
          next if datum.blank?
          datum['id']
        end
      end
    end
  end
end
