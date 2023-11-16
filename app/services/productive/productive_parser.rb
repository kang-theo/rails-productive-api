# frozen_string_literal: true

module Productive
  class ProductiveParser
    attr_accessor :instance_attrs, :instance_klass, :foreign_key_types, :parsed_data

    def initialize(response, instance_klass) # instance_klass parameter, lookup the config mapping table
      if !response.success?
        raise ApiRequestError, "API request failed with status #{response.code}: #{response.body}"
      elsif response.body.blank?
        raise ApiRequestError, "API response is blank"
      end

      @instance_attrs = {}
      @instance_klass = instance_klass
      @foreign_key_types = []
      @parsed_data = JSON.parse(response.body)['data'] # exception
    end

    def handle_response
      instance_results = []

      if parsed_data.is_a?(Array)
        parsed_data.map do |datum|
          @foreign_key_types = []
          parse_attributes_and_types(datum)
          
          klass = "Productive::#{instance_klass}".constantize
          instance_results.push(klass.new(instance_attrs, foreign_key_types))
        end
      else
        parse_attributes_and_types(parsed_data)
        klass = "Productive::#{instance_klass}".constantize
        instance_results.push(klass.new(instance_attrs, foreign_key_types))
      end

    instance_results
    end

    private

    def parse_attributes_and_types(data) # @instance_attrs
      @instance_attrs = data['attributes'].merge(id: data['id'])
      data['relationships'].each do |key, value|
        next unless value.is_a?(Hash)

        data = value['data']
        next if data.blank?

        if data.is_a?(Array)
          # eg. :memberships_id=>["6104455", "6104456", "6104457", "6104464"], and custome_field_people=>[]
          type = data.first['type']
          @foreign_key_types.push(type)
          @instance_attrs[(type.singularize+'_id').to_sym] = data.map do |datum|
            next if datum.blank?
            datum['id']
          end
        else
          type = data['type']
          @foreign_key_types.push(type)
          @instance_attrs[(type.singularize+'_id').to_sym] = data['id']
        end
      end
    end

  end
end