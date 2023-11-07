class Organization < Base
  # DSL
  # has_many :companies
  # has_many :projects, :through => :companies
  # =>
  # o = Organization.new({'id' => ....})
  # o.companies
  # c = o.companies.first #o.companies[2]
  # c.projects
  # o.projects


  def projects
    # step 1: find company
    # step 2: find project through company
  end

  def companies(company_id)
    #....
  end

  def projects(id)
    Componay.find_all(orgnazation_id).each do |cmp|
      cmp.projects
    end
  end
end

# project.company

# organization.company.projects
# organization.projects # => or

