# frozen_string_literal: true

module Productive
  class Project < Base
    include Parser

    def organizations
      associative_query(Organization, organization_id)
    end

    def companies
      associative_query(Company, company_id)
    end

    def memberships
      associative_query(Membership, membership_id)
    end

    def people
      associative_query(Person, person_id)
    end

    def workflows
      associative_query(Workflow, workflow_id)
    end

    private

    def associative_query(klass, ids)
      ids.map { |id| klass.find(id) }
    end
  end
end