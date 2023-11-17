# frozen_string_literal: true

module Productive
  class Company < Base
    def projects
      Project.find(id)
    end
  end
end
