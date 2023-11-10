# frozen_string_literal: true

class Base
  def initialize(response)
    instance_attrs = response['attributes'].merge(id: response['id'])

    response['relationships'].each do |key, value|
      next unless value.is_a?(Hash)

      data = value['data']
      next if data.blank?

      foreign_key = "#{key}_id"
      type = nil

      if data.is_a?(Array)
        # eg. :memberships_id=>["6104455", "6104456", "6104457", "6104464"], and custome_field_people=>[]
        instance_attrs[foreign_key.to_sym] = data.map do |datum|
          next if datum.blank?

          type ||= datum['type']
          datum['id']
        end
      else
        instance_attrs[foreign_key.to_sym] = data['id']
        type = data['type']
      end

      define_foreign_key_methods(type, instance_attrs[foreign_key.to_sym])
    end

    # define setters and getters for instance attributes
    instance_attrs.each do |key, value|
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

  def self.client
    @@client = ProductiveClient.new(self.name.downcase.pluralize)
  end

  # options: {entity: "", id: nil, action: "", data: {}}
  # usage: Project.all, Company.all
  def self.all
    client.get
  end

  def self.find(id)
    entity = client.get({ id: })

    return nil if entity.nil?

    entity.first
  end

  private

  def define_foreign_key_methods(type, ids)
    method_name = type.singularize
    klass = method_name.capitalize

    # define association methods for company, organization, etc. according to each entity's foreign_keys
    if ids.is_a?(Array) # define association methods for multiple memberships, etc.
      self.class.class_eval do
        define_method(method_name.to_sym) do
          ids.map do |id|
            Object.const_get(klass.singularize.capitalize).find(id)
          end
        end
      end
    else
      self.class.class_eval do
        define_method(method_name.to_sym) do
          # Object.const_get(key.capitalize).find(self.send("#{key}_id"))
          Object.const_get(klass).find(ids)
        end
      end
    end
  end
end
