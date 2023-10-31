class Api::V1::ApiTestController < ApplicationController

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

    @project = ProjectClient.find(385299)
    print(@project)

    # find by name
    # @project = ProjectClient.where("name": "test-1")
    # print(@project)

    # find by project id
    # @project = ProjectClient.where("id": 385299)
    # print(@project)

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