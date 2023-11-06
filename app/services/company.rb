class Company

  def initialize(data)
    instance_attrs = data["attributes"].merge({id: data["id"]})

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
end




# class Company
#   attr_accessor :id, ....
               
#   def projects
#     Project.find_all_by_company(self.id)
#   end


# end

# c = Company.new({
#   'id' => "528"
# })

# c.projects