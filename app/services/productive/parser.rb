# frozen_string_literal: true

module Productive
  module Parser
    # extend self
    # module_function

    # attr_accessor :instance_class
    # @instance_attrs = {}
    # @foreign_key_types = []
    class << self
      attr_accessor :instance_class
    end

    def included(base)
      self.instance_class = base
    end

    def self.handle_response(response)
      raise ApiRequestError, "API request failed with status #{response.code}: #{response.body}" unless response.success?
      
      begin
        data_hash = JSON.parse(response.body)['data']
      rescue JSON::ParserError => e
        Rails.logger.error "JSON::ParserError: #{e.message}"
        render json: { error: 'JSON::ParserError' }, status: :bad_response
      end

      attributes = data_hash['attributes'].merge(id: data_hash['id'])
      association_types = []

      data_hash['relationships'].each do |_key, value|
        data = value["data"]

        if data.blank?
          # custom_field_xx, template_object
          next
        elsif data.is_a?(Array)
          type = nil
          ids = data.map do |data| 
            type ||= data["type"]
            data["id"] 
          end

          association_types.push(type)
          attributes["#{type.singularize}_ids"] = ids
        else
          type = data['type']
          id = data["id"]

          association_types.push(type)
          attributes["#{type.singularize}_id"] = id
        end
      end

      debugger

      # build_associations(ids_and_types)
      ids_and_types.each do |item|
        if item.is_a?(Array)
          attributes["#{type.downcase}_ids".to_sym] = ids
        else
          next
          attributes["#{item.downcase}_id".to_sym] = item
        end
      end
    end 

    private

    def self.parse_relationships(relationships)
      relationships.map do |_key, value|
        data = value["data"]

        if data.is_a?(Array)
          data.map { |item| { type: item["type"], id: item["id"] } } 
        elsif data.nil?
          { type: nil, id: nil }
        else
          { type: data["type"], id: data["id"] }
        end
      end
    end

    def build_associations(ids_and_types)
      ids_and_types.each do |item|
        "#{item[:type]}_id"
      end
    end

    def self.parse_attributes_and_types(data, attributes, relationship_types)
      attributes[:id] = data['id']
      attributes.merge!(data['attributes'])



      data['relationships'].each do |_key, value|
        next unless value.is_a?(Hash)

        data = value['data']
        next if data.blank?

        flatten_data = data.is_a?(Array) ? data : [data]
        next if flatten_data.empty? || flatten_data.first.blank?

        # eg. "memberships_id": ["6104455", "6104456", "6104457", "6104464"]
        #     "project_manager": {"data"=>{"type"=>"people", "id"=>"412034"}}
        type = flatten_data.first['type']
        relationship_types.push(type)

        # TODO: id should be conformed to the convention
        attributes[(type.singularize + '_id').to_sym] = flatten_data.map do |datum| # TODO: to many loop and if, need to be concise
          next if datum.blank?
          datum['id']
        end
      end
    end
  end
end
