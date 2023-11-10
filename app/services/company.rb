# frozen_string_literal: true

class Company < Base
  def projects
    Project.find(id)
  end
end
