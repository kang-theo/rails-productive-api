class Base

  def initialize(data)
    instance_attrs = data["attributes"].merge(id: data["id"])

    data["relationships"].each do |key, value|
      foreign_key = "#{key}_id"

      if value.is_a?(Hash)
        data = value["data"]

        unless data.is_a?(Array)
          instance_attrs[foreign_key.to_sym] = data["id"] unless data.blank?
        else
          # eg. :memberships_id=>["6104455", "6104456", "6104457", "6104464"], and custome_field_people=>[]
          instance_attrs[foreign_key.to_sym] = data.map do |datum|
            datum["id"] unless datum.blank?
          end
        end

        define_foreign_key_methods(key, instance_attrs[foreign_key.to_sym])
      end
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
  end # initialize

  def self.client
    @@client = ProductiveClient.new(self.name.downcase.pluralize)
  end

  # options: {entity: "", id: nil, action: "", data: {}}
  # usage: Project.all, Company.all
  def self.all
    client.get(Hash[entity: client.entity])
  end

  def self.find(id)
    entity = client.get(Hash[entity: client.entity, id: id])
    entity.first
  end

  private

  def define_foreign_key_methods(key, ids)
    # define association methods for company, organization, etc. according to each entity's foreign_keys
    unless ids.is_a?(Array)
      self.class.class_eval do
        define_method(key.to_sym) do
          # Object.const_get(key.capitalize).find(self.send("#{key}_id"))
          Object.const_get(key.capitalize).find(ids)
        end
      end
    else # define association methods for multiple memberships, etc.
      self.class.class_eval do
        define_method(key.to_sym) do
          ids.map do |id|
            Object.const_get(key.singularize.capitalize).find(id)
          end
        end
      end
    end
  end

end