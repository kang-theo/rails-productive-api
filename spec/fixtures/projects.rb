module Fixtures
  # use FactoryBot instead
  class Project
    def self.default
      Project.new(property: 'default_value')
    end

    def self.another_state
      Project.new(property: 'another_value')
    end
  end
end
