class Project
  # belongs_to :people
  # belongs_to :workflow
  # belongs_to :organization
  # has_many :member_ships

  def initialize(data)
    instance_attrs = data["attributes"].merge({id: data["id"]})

    data["relationships"].each do |key, value|
      foreign_key = "#{key}_id"

      if value.is_a?(Hash)
        # debugger
        instance_attrs[foreign_key.to_sym] = find_foreign_key_id(value, "id")
      end
    end

    instance_attrs.each do |key, value|
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

  # def to_s
  #   instance_variables.map do |var|
  #     value = instance_variable_get(var)
  #     "#{var}: #{value}"
  #   end
  # end

#   def company
#     # Company.find
#   end

#   def self.find_all_by_company(company_id)
    
#     data.each do |item|
#       if item.relationships.company.data.id ===company_id
#     end
#   end

#   def workflow
# end

#   def organization

#   end

#   def project_manager(id)
#     People.find(id)
#   end

#   def member_ships

#   end
end