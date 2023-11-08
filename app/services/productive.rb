class Productive

  def initialize(data)
    instance_attrs = data["attributes"].merge(id: data["id"])

    data["relationships"].each do |key, value|
      foreign_key = "#{key}_id"

      if value.is_a?(Hash)
        instance_attrs[foreign_key.to_sym] = find_foreign_key_id(value, "id")
      end
    end

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

  # options: {entity: "", id: nil, action: "", data: {}}
  # usage: Project.all, Company.all
  def self.all
    client = get_client
    client.get(Hash[entity: client.entity]) unless client.nil?
  end

  def self.find(id)
    client = get_client
    client.get(Hash[entity: client.entity, id: id]) unless client.nil?
  end


  private

  def find_foreign_key_id(hash, target_key)
    hash.each do |key, value|
      if value.is_a?(Hash)
        result = find_foreign_key_id(value, target_key)
        return result if result
      elsif key == target_key
        return value
      end
    end

    nil
  end

end
