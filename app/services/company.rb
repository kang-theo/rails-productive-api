class Company < Productive
  extend BaseClass

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