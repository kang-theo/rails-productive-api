class Api::V1::ApiTestController < ApplicationController

  def test_get_project_by_id 
    # new attempt
    api_key = "c664831b-4419-4bb0-9dc0-09816f04cea2"
    org_id = "30958"

    # 1. get all projects
    # debugger
    project_api = ProductiveService::ProjectApi.new(api_key, org_id)
    projects = project_api.all
    if projects.is_a?(Array)
      projects.each do |project|
        print(project)
      end
      # projects.each { |project| puts project.to_s }
    else
        # debugger
        print(projects)
    end

    # 2. get a project
    project_api = ProductiveService::ProjectApi.new(api_key, org_id)
    project = project_api.find(385299)
    print(project)

  end

  private
  def print(project)
    printf("--------------------------------------------------- \
          \n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n", 
          "project_id:", project.id,
          "project_type:", project.type,
          "attributes_name:", project.attributes.name,
          "attributes_created_at:", project.attributes.created_at,
          "organization_id:", project.relationships.organization.data.id,
          "company_id:", project.relationships.company.data.id)
    end

end