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

    RELATIONSHIP_PAYLOADS = [
      {association_id: 'company_id', relationship: 'llcompany'},
      {association_id: 'organization_id', relationship: 'organization'},
      {association_id: 'project_manager_id', relationship: 'project_manager'},
      {association_id: 'workflow_id', relationship: 'workflow'},
      {association_id: 'membership_id', relationship: 'memberships'}
    ]
                                          
    # module inclusion
    def Common.included(base) 
      base.extend ClassMethods
      base.include InstanceMethods
    end

    # module definition
    # class methods for entities
    module ClassMethods
      def all
        retrieve_entities_from_api("#{path}")
      end

      def find(id)
        raise ApiRequestError, 'Entity id is invalid.' if id.nil?
        entities = retrieve_entities_from_api("#{path}/#{id}")

        return nil if entities.empty?
        entities.first
      end

      def path
        config = Common::REQ_PARAMS.find { |param| param[:entity] == self.name }
        raise "Entity config not found: #{self.name}" if config.nil?

        @path ||= config[:path]
      end

      def retrieve_entities_from_api(req_params)
        response = HttpClient.get(req_params)
        Parser.handle_response(response, self)
      end
    end

    # instance methods for entities
    module InstanceMethods
      # def update(param_attrs, param_relationships)
      #   config = 
      #   attrs = '"attributes": {' + param_attrs.map { |k, v| %Q("#{k}":#{v.inspect}) }.join(',') + '}'
      #   relationships = '"relationships": {' + param_relationships.map { |k, v| %Q("#{RELATIONSHIP_PAYLOADS.find {|param| param[:association_id] == k}[:relationship]}": { "data": { "type": "#{k.to_s.sub(/_id\z/, '').pluralize}", "id": #{v.inspect} } }) }.join(',') + '}'

      #   payload = '{ "data": { "type": ' + "#{self.name.inspect}" + ', ' + attrs + ', ' + relationships + ' } }'
      #   puts payload

      #   # construct_attributes
      #   # construct_relationships
      #   # response = HttpClient.put("#{path}", payload)
      #   # Parser.handle_response(response, self)
      # end

      # update({name: "project_test", project_num: "1", project_id: 2}, {company_id: "2134", workflow_id: "650"})


    #   def archive; end
    #   def restore; end
    end
  end
end