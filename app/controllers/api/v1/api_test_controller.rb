class Api::V1::ApiTestController < ApplicationController

  def test_get_project_by_id 
    # puts "headers: " + set_headers.to_s

    # @project = Project.all
    # @project = Project.new.one(385299)
    # @project = Project.new(385299).one

    # @project = Project.all
    # @project = Project.find(385299)
    # @project = Project.new(385299).create
    # @project = Project.create
    @project = Project.new(385793, "update_proj2").update
    # @project = Project.delete
    # @project = Project.change_workflow
    
  end

end