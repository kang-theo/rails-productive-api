class Company < Base

  def projects
    Project.find(id)
  end

end
