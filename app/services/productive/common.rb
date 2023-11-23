# frozen_string_literal: true

module Productive
  module Common
    # include Parser

    def self.included(base) # TODO: use new style of included
      base.extend Klass
      # base.include Instance
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
        response = HttpClient.get(path)
        Parser.handle_response(response, self)
      end

      def find(id)
        raise ApiRequestError, 'Entity id is invalid.' if id.nil?

        response = HttpClient.get("#{path}/#{id}")
        entity = Parser.handle_response(response, self)

        return nil if entity.empty?
        entity.first
      end
    end

    # module Instance
    #   # instance methods for entities
    #   def update; end

    #   def archive; end

    #   def restore; end
    # end
  end
end