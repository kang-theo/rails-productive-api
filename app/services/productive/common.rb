# frozen_string_literal: true

module Productive
  def self.included base            
    base.extend Common
    base.include Instance
  end

  module Common
    # usage: Project.all
    def all
      req_params = "#{name.demodulize.downcase.pluralize}" # refactor self.name.demodulize
      response = HttpClient.get(req_params)

      entity = Parser.handle_response(response)
    end

    def find(id)
      raise ApiRequestError, 'Id is invalid.' if id.nil?

      # lookup according to config
      req_params = "#{name.demodulize.downcase.pluralize}/#{id}"
      response = HttpClient.get(req_params)

      entity = Parser.handle_response(response)
      entity.first unless entity.empty?
    end
  end

  module Instance
    # instance methods for entities
    def update; end

    def archive; end

    def restore; end
  end
end