# frozen_string_literal: true

module Productive
  module Common
    # const definition
    RELATIONSHIPS = [
      { type: 'project',         entity: 'Productive::Project'      },
      { type: 'company',         entity: 'Productive::Company'      },
      { type: 'organization',    entity: 'Productive::Organization' },
      { type: 'memberships',     entity: 'Productive::Membership'   },
      { type: 'workflow',        entity: 'Productive::Workflow'     },
      { type: 'project_manager', entity: 'Productive::Person'       },
      { type: 'last_actor',      entity: 'Productive::Person'       },
      { type: 'person',          entity: 'Productive::Person'       },
      { type: 'owner',           entity: 'Productive::Person'       }
    ]

    REQ_PARAMS = [
      { entity: 'Productive::Project',      path: 'projects'      },
      { entity: 'Productive::Company',      path: 'companies'     },
      { entity: 'Productive::Organization', path: 'organizations' },
      { entity: 'Productive::Membership',   path: 'memberships'   },
      { entity: 'Productive::People',       path: 'people'        },
      { entity: 'Productive::Workflow',     path: 'workflows'     }
    ]
                                          
    # module inclusion
    def Common.included(base) 
      base.extend ClassMethods
      # base.include InstanceMethods
    end

    # module definition
    module ClassMethods
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

      def path
        config = Common::REQ_PARAMS.find { |param| param[:entity] == self.name }
        raise "Entity config not found: #{self.name}" if config.nil?

        @path ||= config[:path]
      end
    end

    # module InstanceMethods
    #   # instance methods for entities
    #   def update; end

    #   def archive; end

    #   def restore; end
    # end
  end
end