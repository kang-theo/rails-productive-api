class Project < Productive
  extend BaseClass

  def company
    Company.find(company_id)
  end


# def workflow
# end

# def organization

# end

#   def project_manager(id)
#     People.find(id)
#   end

#   def member_ships

#   end


#   def self.find_all_by_company(company_id)
    
#     data.each do |item|
#       if item.relationships.company.data.id ===company_id
#     end
#   end
end