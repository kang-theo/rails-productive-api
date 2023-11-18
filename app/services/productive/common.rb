# frozen_string_literal: true

module Productive
  module Common
    # usage: Project.all
    def all
      req_params = "#{name.demodulize.downcase.pluralize}" # refactor self.name.demodulize
      response = HttpClient.get(req_params)

      entity = ProductiveParser.handle_response(response, name.demodulize) # refactor self.name.demodulize
    end

    def find(id)
      raise ApiRequestError, 'Id is invalid.' if id.nil?

      # lookup according to config
      req_params = "#{name.demodulize.downcase.pluralize}/#{id}"
      response = HttpClient.get(req_params)

      entity = ProductiveParser.handle_response(response, name.demodulize)

      entity.first unless entity.nil?
    end
  end

  module Instance
    # instance methods for entities
    def update; end

    def archive; end

    def restore; end
  end
end