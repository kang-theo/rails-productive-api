# frozen_string_literal: true

module Productive
  class Project < Base
    include Parser

    def organizations
      organization_id.map do |id|
        Organization.find(id)
      end
    end

    def companies
      company_id.map do |id|
        Company.find(id)
      end
    end

    def memberships
      membership_id.map do |id|
        Membership.find(id)
      end
    end

    def people
      person_id.map do |id|
        Person.find(id)
      end
    end

    def workflows
      workflow_id.map do |id|
        Productive::Workflow.find(id)
      end
    end

    #   def self.find_all_by_company(company_id)

    #     data.each do |item|
    #       if item.relationships.company.data.id ===company_id
    #     end
    #   end
  end
end