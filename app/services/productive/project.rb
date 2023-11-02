module Productive
  class Project
    def initialize(data)
      @data = data
      create_accessors
    end

    def create_accessors
      raise "Data is invalid." if @data.nil?
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

    def to_s
      instance_variables.map do |var|
        value = instance_variable_get(var)
        "#{var}: #{value}"
      end
    end
  end

end