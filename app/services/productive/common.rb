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
      {association_id: 'company_id', relationship: 'company'},
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

      private

      def path
        # test removing Common
        config = REQ_PARAMS.find { |param| param[:entity] == self.name }
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
      include HttpClient

      def create(attrs, relationships = {})
        response = HttpClient.post("#{path}", build_payload(attrs, relationships))
        Parser.handle_response(response, self)
      end
      # p = Productive::Project.find(399787)
      # p.create({name: "create 1", project_manager_id: "561888", project_type_id: 1}, {company_id: "699400", project_manager_id: "561888", workflow_id: "32544"})

      def update(attrs, relationships = {})
        response = HttpClient.patch("#{path}/#{id}", build_payload(attrs, relationships))
        Parser.handle_response(response, self)
      end
      # p = Productive::Project.find(399787)
      # p.update({name: "update 1"})

      private

      def build_payload(attrs, relationships)
        # build_attributes
        attr_header = '"attributes": {'
        attr_body = attrs.map { |k, v| %Q("#{k}":#{v.inspect}) }.join(',')
        attr_footer = '}'

        attrs = attr_header + attr_body + attr_footer
        # attrs = '"attributes": {' + param_attrs.map { |k, v| %Q("#{k}":#{v.inspect}) }.join(',') + '}'

        # build_relationships
        relationship_header = '"relationships": {'
        relationship_body = relationships.map do |k, v| 
          %Q("#{RELATIONSHIP_PAYLOADS.find {|param| param[:association_id] == k.to_s}[:relationship]}": { "data": { "type": "#{k.to_s.sub(/_id\z/, '').pluralize}", "id": #{v.inspect} } }) 
        end.join(',')
        relationship_footer = '}'

        relationships = relationship_header + relationship_body + relationship_footer
        # relationships = '"relationships": {' + param_relationships.map { |k, v| %Q("#{RELATIONSHIP_PAYLOADS.find {|param| param[:association_id] == k.to_sym}}": { "data": { "type": "#{k.to_s.sub(/_id\z/, '').pluralize}", "id": #{v.inspect} } }) }.join(',') + '}'

        # build payload
        '{ "data": { "type": ' + %Q("#{REQ_PARAMS.find { |param| param[:entity] == self.class.name }[:path]}") + ',' + attrs + ',' + relationships + '} }'
      end

      # TODO: refactor, self.included
      def path
        config = REQ_PARAMS.find { |param| param[:entity] == self.class.name }
        raise "Entity config not found: #{self.class.name}" if config.nil?

        @path ||= config[:path]
      end

      # def retrieve_entities_from_api(req_params)
      #   response = HttpClient.get(req_params)
      #   Parser.handle_response(response, self)
      # end
    end
  end
end