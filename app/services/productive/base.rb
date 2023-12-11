# frozen_string_literal: true

module Productive
  class Base
    include Common
    include Parser

    # TODO: can be defined in class directly
    def changes
      @changes ||= {}
    end
    
    def changed_attrs
      @changed_attrs ||= {}
    end

    def changed_relationships
      @changed_relationships ||= {}
    end

    # TODO: set required attributes when creating an instance
    def initialize(attributes = {}, association_info = {})
      # raise 'ApiRequestError: attributes is blank' if attributes.blank?

      attributes.merge!({ name: "", project_type_id: nil, project_manager_id: "", company_id: "", workflow_id: "" }) if attributes.empty?
      create_accessors(attributes)
      define_associations(association_info) if association_info.present?
    end

    # ActiveRecord style assign_attributes
    def assign_attributes(attributes)
      attributes.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
    end

    # customize the output of the object
    def inspect
      attributes_to_exclude = [:@changed_attrs, :@changed_relationships, :@changes]
      filtered_instance_variables = instance_variables.reject do |var|
        attributes_to_exclude.include?(var.to_sym)
      end

      filtered_attributes = filtered_instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete("@")] = instance_variable_get(var)
      end

      "#<#{self.class}:#{object_id} #{filtered_attributes}>"
    end

    private

    # for instance attributes
    def create_accessors(attributes)
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)

        class_eval do
          define_method(key) { instance_variable_get("@#{key}") }
          define_method("#{key}=") do |value| 
            track_change("#{key}".to_sym, send("#{key}"), value)
            instance_variable_set("@#{key}", value)
          end
        end
      end
    end

    # for associative queries
    def define_associations(association_info)
      association_info.each do |key, value|
        # key: membership, etc
        config = Common::ENTITY_RELATIONSHIP.find { |relationship| relationship[:relationship_key] == key }
        raise ApiRequestError, 'Undefined relationship.' if config.nil?

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