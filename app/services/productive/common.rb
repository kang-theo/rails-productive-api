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
        config = PRODUCTIVE_CONF['req_params']
        entity_config = config.find { |param| param['entity'] == name }
        raise "Entity config not found: #{name}" if entity_config.nil?

        @path ||= entity_config['path']
      end

      # usage: Project.all
      def all
        req_params = path
        response = HttpClient.get(req_params)

        Parser.handle_response(response)
      end

      def find(id)
        raise ApiRequestError, 'Entity id is invalid.' if id.nil?

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