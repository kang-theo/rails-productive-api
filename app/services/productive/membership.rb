# frozen_string_literal: true

module Productive
  class Membership < Base
    include Parser

    def organizations
      associative_query(Organization, organization_id)
    end

    def people
      associative_query(Person, person_id)
    end

    def teams
      associative_query(Team, team_id)
    end

    def deals
      associative_query(Deal, deal_id)
    end

    def project
      associative_query(Project, project_id)
    end

    private

    def associative_query(klass, ids)
      ids.map { |id| klass.find(id) }
    end
  end
end
