# frozen_string_literal: true

class Productive::ProductiveParser
  attr_accessor :attributes, :foreign_key_types, :response

  def initialize(response)
    if !response.success?
      raise ApiRequestError, "API request failed with status #{response.code}: #{response.body}"
    elsif response.body.blank?
      raise ApiRequestError, "API response is blank"
    end

    @attributes = {}
    @foreign_key_types = []
    @response = response
    parse_attributes_and_types(response)
  end

  private

  def handle_response
    parsed_data = JSON.parse(response.body)['data']
    module_name = self.class.module_parent.name
    # "projects" -> "Project"
    klass = entity.singularize.capitalize
    entity_result = []

    if parsed_data.is_a?(Array)
      parsed_data.map do |datum|
        parse_attributes_and_types(datum)
        entity_result.push(Object.const_get("#{module_name}::#{klass}").new(instance_attrs, foreign_key_types))
      end
    else
      parse_attributes_and_types(datum)
      entity_result.push(Object.const_get("#{module_name}::#{klass}").new(item))
    end
  end


  def parse_attributes_and_types(data)
    foreign_key_types = []
    instance_attrs = data['attributes'].merge(id: data['id'])
    response['relationships'].each do |key, value|
      next unless value.is_a?(Hash)

      data = value['data']
      next if data.blank?

      foreign_key = "#{key}_id"

      if data.is_a?(Array)
        # eg. :memberships_id=>["6104455", "6104456", "6104457", "6104464"], and custome_field_people=>[]
        instance_attrs[foreign_key.to_sym] = data.map do |datum|
          next if datum.blank?

          foreign_key_types ||= datum['type']
          datum['id']
        end
      else
        instance_attrs[foreign_key.to_sym] = data['id']
        foreign_key_types = data['type']
      end
    end
  end

end
