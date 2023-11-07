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
    # project_api = Productive::ProjectApi.new()
    # project = project_api.find(385299)
    # project_api = ProjectApi.new()
    # project = project_api.find(385299)

    # Utils.print(project.first)

    # 3. update value
    # project_api = Productive::ProjectApi.new()
    # project = project_api.find(385780)

    # # debugger
    # project.first.id = "12345"

    # 4. test project_attrs
    # ProjectAttr.new({ "name": "test project", "number": "1", "project_number": "1", "project_type_id": "2", "project_color_id": "null", "last_activity_at": "2023-10-23T06:10:48.000+02:00", "public_access": true, "time_on_tasks": true, "tag_colors": {}, "archived_at": "null", "created_at": "2023-10-23T06:10:48.107+02:00", "template": false, "budget_closing_date": "null", "needs_invoicing": false, "custom_fields": "null", "task_custom_fields_ids": "null", "sample_data": false })

    # 5. exception
    project_api = ProductiveClient.new("projects")
    project = project_api.find(385780)
  end
end