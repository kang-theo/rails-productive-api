# frozen_string_literal: true

module Productive
  module ProductiveParser
    @@instance_attrs = {}
    @@foreign_key_types = []
    
    def self.instance_attrs
      @@instance_attrs
    end
    
    def self.foreign_key_types
      @@foreign_key_types
    end

    def self.handle_response(response, instance_klass)
      raise ApiRequestError, "API request failed with status #{response.code}: #{response.body}" unless response.success?
      raise ApiRequestError, "API response is blank" if response.body.blank?
        
      parsed_data = JSON.parse(response.body)['data']
      instance_results = []

      flatten_data = parsed_data.is_a?(Array) ? parsed_data : [parsed_data]
      flatten_data.each do |datum|
        foreign_key_types.clear
        parse_attributes_and_types(datum)

        klass = "Productive::#{instance_klass}".constantize
        instance_results.push(klass.new(instance_attrs, foreign_key_types))
      end
      instance_results
    end

    private

    def self.parse_attributes_and_types(data)
      instance_attrs[:id] = data['id']
      instance_attrs.merge!(data['attributes'])

      data['relationships'].each do |_key, value|
        next unless value.is_a?(Hash)

        data = value['data']
        next if data.blank?

        if data.is_a?(Array)
          next if data.empty? || data.first.blank?

          # eg. "memberships_id": ["6104455", "6104456", "6104457", "6104464"]
          type = data.first['type']
          foreign_key_types.push(type)

          instance_attrs[(type.singularize + '_id').to_sym] = data.map do |datum|
            next if datum.blank?
            datum['id']
          end
        else
          next if data.blank?

          # eg. "project_manager": {"data"=>{"type"=>"people", "id"=>"412034"}}
          type = data['type']
          foreign_key_types.push(type)

          instance_attrs[(type.singularize + '_id').to_sym] = data['id']
        end
      end
    end
  end
end
