class Utils
  def self.print(project)
    # debugger
    printf("--------------------------------------------------- \
          \n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n", 
          "project_id:", project.id,
          "project_type:", project.type,
          "attributes_name:", project.name,
          "attributes_created_at:", project.created_at,
          "organization_id:", project.organization_id,
          "company_id:", project.company_id)
    end
end