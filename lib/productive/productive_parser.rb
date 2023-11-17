# frozen_string_literal: true

module Productive
  module ProductiveParser
    # attr_accessor :instance_attrs, :instance_klass, :foreign_key_types, :parsed_data


    #   @instance_attrs = {}
    #   @instance_klass = instance_klass
    #   @foreign_key_types = []
    #   @parsed_data = JSON.parse(response.body)['data'] # exception
    # end

    @@instance_attrs = {}
    @@foreign_key_types = []
    
    def self.instance_attrs
      @@instance_attrs
    end
    
    # def self.update_instance_attrs(key, value)
    #   @@instance_attrs[key] = value
    # end

    def self.foreign_key_types
      @@foreign_key_types
    end

    # def self.foreign_key_types=(types)
    #   @@foreign_key_types = types
    # end

    def self.handle_response(response, instance_klass)
      raise ApiRequestError, "API request failed with status #{response.code}: #{response.body}" unless response.success?
      raise ApiRequestError, "API response is blank" if response.body.blank?
        
      parsed_data = JSON.parse(response.body)['data']
      instance_results = []

      if parsed_data.is_a?(Array)
        parsed_data.map do |datum|
          foreign_key_types.clear
          parse_attributes_and_types(datum)

          klass = "Productive::#{instance_klass}".constantize
          instance_results.push(klass.new(instance_attrs, foreign_key_types))
        end
      else
        parse_attributes_and_types(parsed_data)
        klass = "Productive::#{instance_klass}".constantize
        instance_results.push(klass.new(instance_attrs, foreign_key_types))
      end
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
          # eg. :memberships_id=>["6104455", "6104456", "6104457", "6104464"], and custome_field_people=>[]
          type = data.first['type']
          foreign_key_types.push(type)

          instance_attrs[(type.singularize + '_id').to_sym] = data.map do |datum|
            next if datum.blank?
            datum['id']
          end
        else
          # "project_manager"=>{"data"=>{"type"=>"people", "id"=>"412034"}}, multiple people
          type = data['type']
          foreign_key_types.push(type)

          instance_attrs[(type.singularize + '_id').to_sym] = data['id']
        end
      end
    end
  end
end
