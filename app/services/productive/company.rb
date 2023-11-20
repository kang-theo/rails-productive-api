# frozen_string_literal: true

module Productive
  class Company < Base
    include Parser

    validates :company_code, :projcetless_budgets, presence: true

    def projects
      associative_query(Project, project_id)
    end

    def organizations
      associative_query(Organization, organization_id)
    end

    private

    def associative_query(klass, ids)
      ids.map { |id| klass.find(id) }
    end
  end
end
