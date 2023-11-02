class Api::V2::ProjectsController < ApplicationController

  def all
    # new attempt
    # 1. get all projects
    # debugger
    # project_api = Productive::ProjectApi.new()
    # begin
    #   projects = project_api.all
    # rescue e
    #   puts "Error: #{e.message}"
    # end

    # if projects.is_a?(Array)
    #   projects.each do |project|
    #     Utils.print(project)
    #   end
    #   # projects.each { |project| puts project.to_s }
    # end

    # # 2. get a project
    project_api = Productive::ProjectApi.new()
    project = project_api.find(385299)

    Utils.print(project.first)

    # 3. update value
    # project_api = Productive::ProjectApi.new()
    # project = project_api.find(385780)

    # # debugger
    # project.first.id = "12345"
  end
end