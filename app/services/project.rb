class Project < Productive
  extend BaseClass

  def initialize(data)
    super(data)
    # define foreign key methods for company, organization, workflow, etc
    data["relationships"].each do |key, value|
      self.class.class_eval do
        define_method(key.to_sym) do
          Object.const_get(key.capitalize).find(self.send("#{key}_id"))
        end
      end
    end
  end

  def self.copy

  end

#   def self.find_all_by_company(company_id)
    
#     data.each do |item|
#       if item.relationships.company.data.id ===company_id
#     end
#   end
end