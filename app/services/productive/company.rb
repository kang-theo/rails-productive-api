# frozen_string_literal: true

class Productive::Company < Productive::Base
  def projects
    Project.find(id)
  end
end
