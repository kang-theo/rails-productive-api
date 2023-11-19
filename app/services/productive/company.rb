# frozen_string_literal: true

module Productive
  class Company < Base
    include Parser

    def projects
      project_id.map do |id|
        Project.find(id)
      end
    end

    def organizations
      organization_id.map do |id|
        Organization.find(id)
      end
    end
  end
end
