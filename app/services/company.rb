class Company < Productive

  def projects
    Project.find(id)
  end

end
