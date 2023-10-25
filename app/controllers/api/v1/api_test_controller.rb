class Api::V1::ApiTestController < ApplicationController
  include ProjectsApi

  def test_get_project_by_id 
    # result = get_project_by_id 560
    # puts result

    # puts "headers: " + set_headers.to_s

    @project = ProjectsApi::Projects.new()
    @project.get_projects
    # @project.get_project_by_id 566
    @project.create_project
  end

end