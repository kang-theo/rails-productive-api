class ProjectAttr
  # { "name": "test project", "number": "1", "project_number": "1", "project_type_id": "2", "project_color_id": "null", "last_activity_at": "2023-10-23T06:10:48.000+02:00", "public_access": true, "time_on_tasks": true, "tag_colors": {}, "archived_at": "null", "created_at": "2023-10-23T06:10:48.107+02:00", "template": false, "budget_closing_date": "null", "needs_invoicing": false, "custom_fields": "null", "task_custom_fields_ids": "null", "sample_data": false }
  def initialize(attrs)
    @attrs = attrs
    create_accessors
  end

  def create_accessors
    if @attrs.blank?
      raise "Invalid attributes." 
    end

    @attrs.each do |key, value|
      # puts key, value
      class_eval do
        define_method(key) do
          # instance_variable_get("@#{key}")
          value
        end

        define_method("#{key}=") do |new_value|
          # instance_variable_set("@#{key}", new_value)
           @attrs[key] = new_value

        end
      end
    end
  end

  def keys
    @attrs.keys
  end

  def to_s
    instance_variables.map do |var|
      value = instance_variable_get(var)
      "#{var}: #{value}"
    end
  end
end