# frozen_string_literal: true

module Productive
  class Person< Base
    def projects
      Project.find(id)
    end
  end
end