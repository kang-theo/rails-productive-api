# frozen_string_literal: true

module Productive
  module Common
    def self.included(base)
      base.extend Klass
      base.include Instance
    end

    module Klass
      # self.extended instead
      def path
        @path ||= begin
          config = PRODUCTIVE_CONF['req_params']
          config.find { |param| param['entity'] == name }['path']
        end
      end

      # usage: Project.all
      def all
        req_params = path
        response = HttpClient.get(req_params)

        entity = Parser.handle_response(response)
      end

      def find(id)
        raise ApiRequestError, 'Id is invalid.' if id.nil?

        req_params = "#{path}/#{id}"
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