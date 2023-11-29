# frozen_string_literal: true

module Productive
  class Base
    include Common
    include Parser

    def initialize(attributes, association_info)
      raise 'ApiRequestError: attributes is blank' if attributes.blank?
      raise 'ApiRequestError: association_info is blank' if association_info.blank?

      create_accessors(attributes)
      define_associations(association_info)
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
    def define_associations(association_info)
      association_info.each do |key, value|
        # key: membership, etc
        # TODO: 是不是真的需要这个配置文件？
        config = Common::RELATIONSHIPS.find { |relationship| relationship[:type] == key }
        raise ApiRequestError, 'Undefined type.' if config.nil?

        # eg. Membership.find(id)
        klass = "#{config[:entity]}".constantize
        ids = Array(value)

        # define association methods
        class_eval do
          define_method(key.to_sym) { ids.map { |id| klass.find(id) } }
        end
      end
    end
  end
end