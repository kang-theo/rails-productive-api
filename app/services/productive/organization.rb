# frozen_string_literal: true

module Productive
  class Organization < Base
    include Parser

    def people # owner
      associative_query(Person, person_id)
    end

    def companies
      associative_query(Company, company_id)
    end

    def organization_subscription
      associative_query(OrganizationSubscription, organization_subscription_id)
    end

    private

    def associative_query(klass, ids)
      ids.map { |id| klass.find(id) }
    end
  end
end
