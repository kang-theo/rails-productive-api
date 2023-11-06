class Project
  # belongs_to :people
  # belongs_to :workflow
  # belongs_to :organization
  # has_many :member_ships

# testing data: {"id": 1, "type": "testc", "attributes": { "name": "test project", "number": "1", "project_number": "1", "project_type_id": "2", "project_color_id": "null", "last_activity_at": "2023-10-23T06:10:48.000+02:00", "public_access": true, "time_on_tasks": true, "tag_colors": {}, "archived_at": "null", "created_at": "2023-10-23T06:10:48.107+02:00", "template": false, "budget_closing_date": "null", "needs_invoicing": false, "custom_fields": "null", "task_custom_fields_ids": "null", "sample_data": false }}
  def initialize(data)
    # think about id and type later
    attributes = data["attributes"]
    attributes.each do |key, value|
      instance_variable_set("@#{key}", value)
      # instance_variable_get("@#{key}")

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

  def to_s
    instance_variables.map do |var|
      value = instance_variable_get(var)
      "#{var}: #{value}"
    end
  end

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