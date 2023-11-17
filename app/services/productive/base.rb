# frozen_string_literal: true

module Productive
  class Base
    def initialize(attributes, foreign_key_types)
      raise 'ApiRequestError: attributes is blank' if attributes.blank?
      raise 'ApiRequestError: foreign_key_types is blank' if foreign_key_types.blank?

      create_accessors(attributes)
      define_associations(attributes, foreign_key_types)
    end

    # usage: Project.all, Company.all
    def self.all
      req_params = "#{name.demodulize.downcase.pluralize}" # refactor self.name.demodulize
      response = HttpClient.get(req_params)

      entity = ProductiveParser.handle_response(response, name.demodulize) # refactor self.name.demodulize
    end

    def self.find(id)
      raise ApiRequestError, 'Id is invalid.' if id.nil?

      # lookup according to config
      req_params = "#{name.demodulize.downcase.pluralize}/#{id}"
      response = HttpClient.get(req_params)

      entity = ProductiveParser.handle_response(response, name.demodulize)

      entity.first unless entity.nil?
    end

    private

    def create_accessors(attributes)
      # define setters and getters for instance attributes
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)

        class_eval do
          define_method(key) do
            instance_variable_get("@#{key}")
          end

          define_method("#{key}=") do |value|
            instance_variable_set("@#{key}", value)
          end
        end
      end
    end

    def define_associations(attributes, types) # type parse
      types.each do |type|
        method_name = type.singularize
        ids = attributes[(method_name + '_id').to_sym]

        # lookup the configured relationship
        target = ProductiveConf.relationships.find { |relationship| relationship[:type] == type }
        klass = "Productive::#{target[:entity]}".constantize unless target.nil?

        # define association methods for company, organization, etc.
        if ids.is_a?(Array) # define association methods for multiple memberships, etc.
          self.class.class_eval do
            define_method(method_name.to_sym) do
              ids.map do |id|
                klass.find(id)
              end
            end
          end
        else
          self.class.class_eval do
            define_method(method_name.to_sym) do
              klass.find(ids)
            end
          end
        end
      end
    end
  end
end
