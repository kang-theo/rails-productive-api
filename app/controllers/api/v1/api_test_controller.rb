class Api::V1::ApiTestController < ApplicationController
  include ProjectApi

  def test_get_project_by_id 
    # result = get_project_by_id 560
    # puts result

    # puts "headers: " + set_headers.to_s

    @project = ProjectApi::Project.new()
    # @project.all
    # @project.one (385299)
    # @project.create
    # @project.update (385299)
    @project.archive (385299)
  end

end