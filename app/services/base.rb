class Base

  def initialize(data)
    instance_attrs = data["attributes"].merge(id: data["id"])

    data["relationships"].each do |key, value|
      foreign_key = "#{key}_id"
      puts key

      if value.is_a?(Hash)
        data = value["data"]

        if data.is_a?(Array)
          # :memberships_id=>["6104455", "6104456", "6104457", "6104464"]
          instance_attrs[foreign_key.to_sym] = data.map do |datum|
            datum["id"] unless datum.blank?
          end
        else
          instance_attrs[foreign_key.to_sym] = data["id"] unless data.blank?
        end
      end

      # define association methods for company, organization, workflow, etc according to each entity's foreign_keys
      self.class.class_eval do
        define_method(key.to_sym) do
          Object.const_get(key.capitalize).find(self.send("#{key}_id"))
        end
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
  end

  def self.client
    @@client ||= ProductiveClient.new(self.name.downcase.pluralize)
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

  # def find_foreign_key_id(hash, target_key)
  #   hash.each do |key, value|
  #     if value.is_a?(Hash)
  #       result = find_foreign_key_id(value, target_key)
  #       return result if result
  #     elsif key == target_key
  #       return value
  #     end
  #   end

  #   nil
  # end

end
