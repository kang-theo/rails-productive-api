# frozen_string_literal: true

module Productive
  class Base
    def initialize(attributes, foreign_key_types)
      raise "ApiRequestError: attributes is blank" if attributes.blank?
      raise "ApiRequestError: foreign_key_types is blank" if foreign_key_types.blank?

      create_setter_and_getter(attributes)
      define_association_methods(attributes, foreign_key_types)
    end

    # usage: Project.all, Company.all
    def self.all
      req_params = "#{self.name.demodulize.downcase.pluralize}" # refactor self.name.demodulize 
      response = http_client.get(req_params)

      parser = ProductiveParser.new(response, self.name.demodulize) # refactor self.name.demodulize 
      entity = parser.handle_response
    end

    def self.find(id)
      raise ApiRequestError, 'Id is invalid.' if id.nil?

      # lookup according to config
      req_params = "#{self.name.demodulize.downcase.pluralize}/#{id}"
      response = HttpClient.get(req_params)

      parser = ProductiveParser.new(response, self.name.demodulize)
      entity = parser.handle_response

      entity.first unless entity.nil?
    end

    private

    def create_setter_and_getter(attributes)
      # define setters and getters for instance attributes
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)

        self.class_eval do
          define_method(key) do
            instance_variable_get("@#{key}")
          end

          define_method("#{key}=") do |value|
            instance_variable_set("@#{key}", value)
          end
        end
      end
    end

    def define_association_methods(attributes, types) # type parse
      types.each do |type|
        method_name = type.singularize
        ids = attributes[(method_name + '_id').to_sym]

        # lookup the configured relationship
        target = ProductiveConf.relationships.find{|relationship| relationship[:type] == type}
        unless target.nil?
          klass = "Productive::#{target[:entity]}".constantize 
        end

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
            self.define_method(method_name.to_sym) do
              klass.find(ids)
            end
          end
        end
      end
    end

    def define_custom_method(name, params)
      define_method(name.to_sym) do
        klass.find(params)
      end
    end

  end
end