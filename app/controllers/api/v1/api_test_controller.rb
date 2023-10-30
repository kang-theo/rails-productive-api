class Api::V1::ApiTestController < ApplicationController

  def test_get_project_by_id 
    # @project = Project.all
    # @project = Project.new(385299).create
    # @project = Project.create
    # @project = Project.new(385793, "update_proj2").update
    # @project = Project.delete
    # @project = Project.change_workflow
    # @project = ProjectClient.find(385299)

    @projects = ProjectClient.all
    # # @projects.each do |project|
    #   # print(@projects)
    # # end
    # print(@projects.first)
    @projects.each do |key, value|
      print(value)
    end

    @project = ProjectClient.where("name":"test-1")
    puts "===================================="
    print(@project)
  end

  private
  def print(project)
    printf("------------------------------------\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n%-22s %s\n", 
          "name:", project.name,
          "organization_type:", project.organization_type,
          "organization_id:", project.organization_id,
          "company_type:", project.company_type,
          "company_id:", project.company_id,
          "project_manager_type:", project.project_manager_type,
          "project_manager_id:", project.project_manager_id,
          "project_workflow_type:", project.workflow_type,
          "project_workflow_id:", project.workflow_id)

    # project.instance_variables.each do |var|
    #   var_name = var.to_s.delete("@")
    #   value = project.instance_variable_get(var)
    #   printf("%-12s %s\n", var_name + ":", value)
    # end
  end

end