# app/models/project.rb
class Project
  def initialize(data)
    @data = data
    create_accessors
  end

  def create_accessors
    @data.each do |key, value|
      # puts key, value
      define_singleton_method(key) do
        if value.is_a?(Hash)
          self.class.new(value)
        elsif value.is_a?(Array)
          value.map { |item| item.is_a?(Hash) ? self.class.new(item) : item }
        else
          value
        end
      end

      # define_singleton_method("#{key}=") do |new_value|
      #   @data[key] = new_value if !value.is_a?(Hash) && !value.is_a?(Array)
      # end
      if !value.is_a?(Hash) && !value.is_a?(Array)
        # debugger
        define_singleton_method("#{key}=") do |new_value|
          self.class.instance_variable_set("@#{key}", new_value)
          @data[key] = new_value
        end
      end
    end
  end

  # def set_value(key, new_value)
  #   instance_variable_set("@#{key}", new_value)
  # end

  def to_s
    instance_variables.map do |var|
      value = instance_variable_get(var)
      "#{var}: #{value}"
    end
  end
end

  # def to_s
  #   # debugger
  #   "Project ID: #{id}\n" \
  #   "Project Type: #{type}\n" \
  #   # "Project Attributes: #{attributes}\n" \
  #   # "Project Relationships: #{relationships}\n" \
  #   # Add additional attributes as needed
  #   # "-------------------------\n"
  # end