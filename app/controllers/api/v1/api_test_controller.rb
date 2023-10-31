class Api::V1::ApiTestController < ApplicationController
  # include ProductiveService

  def test_get_project_by_id 
    # @project = Project.all
    # @project = Project.new(385299).create
    # @project = Project.create
    # @project = Project.new(385793, "update_proj2").update
    # @project = Project.delete
    # @project = Project.change_workflow
    # @project = ProjectClient.find(385299)

    # @projects = ProjectClient.all
    # @projects.each do |key, value|
    #   print(value)
    # end

    # @project = ProjectClient.find(385299)
    # print(@project)

    # find by name
    # @project = ProjectClient.where("name": "test-1")
    # print(@project)

    # find by project id
    # ProjectClient.new("2", "test")
    # @project = ProjectClient.where("id": 385299)
    # print(@project)

    # new attempt
    # In your controller or wherever you want to use the API
    # api_key = 'your_api_key_here'
    # productive_api = ProductiveAPI.new(api_key)
    puts "1-----"
    productive_api = ProductiveService::ProductiveApi.new()
    projects = productive_api.get_projects
    puts projects.class
    projects.each do |project|
      # print(project)
    end
    # puts projects.is_a?(Array)
    # if projects.is_a?(Array)
    #   # puts projects.map(&:to_s).join
    #   projects.each { |project| puts project.to_s }
    # else
    #   projects.to_s
    # end
    # 'projects' now contains an array of OpenStruct objects representing your JSON data


  end



  private
  def print(project)
    printf("------------------------------------\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n", 
          "project_name:", project.name,
          "project_id:", project.id,
          "organization_id:", project.organization_id,
          "company_id:", project.company_id,
          "project_manager_id:", project.project_manager_id,
          "project_workflow_id:", project.workflow_id)
    end

end