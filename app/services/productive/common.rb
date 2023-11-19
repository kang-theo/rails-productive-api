# frozen_string_literal: true

module Productive
  module Common
    def self.included base            
      base.extend Klass
      base.include Instance
    end

    module Klass
      # usage: Project.all
      def all
        target = ProductiveConf.req_params_mapping.find { |map| map[:entity] == self.name }

        req_params = target[:path]
        response = HttpClient.get(req_params)

        entity = Parser.handle_response(response)
      end

      def find(id)
        raise ApiRequestError, 'Id is invalid.' if id.nil?

        # lookup according to config
        target = ProductiveConf.req_params_mapping.find { |map| map[:entity] == self.name }

        req_params = "#{target[:path]}/#{id}"
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
end