# frozen_string_literal: true

module Productive
  class Project < Base
    # project has many memberships, memberships has one project, they are one-many relationship, so the memberships should have a foreign key of project_id
  end
end