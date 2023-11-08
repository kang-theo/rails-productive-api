class Organization < Productive
  extend BaseClass

end

def projects
  Project.find_all_by_company(id)
end