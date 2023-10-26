class Api::V1::ApiTestController < ApplicationController
  include ProjectApi

  def test_get_project_by_id 
    # result = get_project_by_id 560
    # puts result

    # puts "headers: " + set_headers.to_s

    @project = ProjectApi::Project.new()
    # @project.all
    # @project.one (566)
    # @project.create
    # @project.update (384780)
    @project.archive (384780)
  end

end