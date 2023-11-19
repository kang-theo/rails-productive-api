# frozen_string_literal: true

module Productive
  class Project < Base
    include Parser

    def initialize(attributes, foreign_key_types)
      super(attributes, foreign_key_types)
    end

    def self.copy; end

    #   def self.find_all_by_company(company_id)

    #     data.each do |item|
    #       if item.relationships.company.data.id ===company_id
    #     end
    #   end
  end
end