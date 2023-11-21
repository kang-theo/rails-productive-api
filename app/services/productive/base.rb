# frozen_string_literal: true

module Productive
  class Base
    include Common

    def initialize(attributes, foreign_key_types)
      raise 'ApiRequestError: attributes is blank' if attributes.blank?
      raise 'ApiRequestError: foreign_key_types is blank' if foreign_key_types.blank?

      create_accessors(attributes)
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

    # for associative queries
    def define_associations(attributes, types)
      types.each do |type|
        config = PRODUCTIVE_CONF['relationships']
        type_hash = config.find { |relationship| relationship['type'] == type }
        raise ApiRequestError, 'Undefined type.' if type_hash.nil?

        klass = type_hash['entity']
        method_name = klass.downcase
        ids = attributes["#{method_name}_id".to_sym] # TODO: id || ids

        # define association methods for company, organization, etc.
        flatten_ids = ids.is_a?(Array)? ids : [ids]
        self.class_eval do
          define_method(method_name.to_sym) do
            klass = "Productive::#{klass}"
            flatten_ids.each { |id| klass.constantize.find(id) }
          end
        end
      end
    end
  end
end
