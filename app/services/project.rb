# app/models/project.rb
class Project
  def initialize(data)
    @data = data
    create_accessors
  end

  def create_accessors
    @data.each do |key, value|
      define_singleton_method(key) do
        if value.is_a?(Hash)
          self.class.new(value)
        elsif value.is_a?(Array)
          value.map { |item| item.is_a?(Hash) ? self.class.new(item) : item }
        else
          value
        end
      end
    end
  end

  # def to_s
  #   puts id
  #   puts "Calling to_s method!"
  #   "Project ID: #{id}\n" \
  #   "Project Type: #{type}\n" \
  #   # "Project Attributes: #{attributes}\n" \
  #   # "Project Relationships: #{relationships}\n" \
  #   # Add additional attributes as needed
  #   "-------------------------\n"
  # end

  # def to_s
  #   instance_variables.map do |var|
  #     value = instance_variable_get(var)
  #     "#{var}: #{value}"
  #   end.join("\n\n\n")
  # end
end
