# frozen_string_literal: true

module Productive
  class Base
    include Common
    include Parser

    def initialize(attributes, association_types)
      raise 'ApiRequestError: attributes is blank' if attributes.blank?
      raise 'ApiRequestError: association_types is blank' if association_types.blank?

      create_accessors(attributes)
      # define_associations(attributes, association_types)
    end

    private

    # for instance attributes
    def create_accessors(attributes)
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)

        class_eval do
          define_method(key) { instance_variable_get("@#{key}") }
          define_method("#{key}=") { |value| instance_variable_set("@#{key}", value) }
        end
      end
    end

    # TODO: refactor the method
    # for associative queries
    def define_associations(attributes, types)
      types.each do |type|
        config = PRODUCTIVE_CONF['relationships']
        type_config = config.find { |relationship| relationship['type'] == type }
        raise ApiRequestError, 'Undefined type.' if type_config.nil?

        entity = type_config['entity']
        method_name = entity.downcase
        ids = attributes["#{method_name}_id".to_sym] # TODO: id || ids

        # define association methods for company, organization, etc.
        flatten_ids = Array(ids)
        self.class_eval do
          define_method(method_name.to_sym) do
            klass = "Productive::#{entity}"
            flatten_ids.each { |id| klass.constantize.find(id) }
          end
        end
      end
    end
  end
end
