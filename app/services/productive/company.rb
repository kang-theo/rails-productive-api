# frozen_string_literal: true

module Productive
  class Company < Base
    include Parser

    def projects
      Project.find(id)
    end
  end
end
