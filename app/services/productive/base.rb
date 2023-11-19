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
  end
end
