# frozen_string_literal: true

module Productive
  module Common
    # const definition -----------------------------------------------------------
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
      {association_id: 'company_id',         relationship: 'company'        },
      {association_id: 'organization_id',    relationship: 'organization'   },
      {association_id: 'project_manager_id', relationship: 'project_manager'},
      {association_id: 'workflow_id',        relationship: 'workflow'       },
      {association_id: 'membership_id',      relationship: 'memberships'    }
    ]
                                          
    # module inclusion -----------------------------------------------------------
    def Common.included(base) 
      base.extend ClassMethods
      base.include InstanceMethods
    end

    # module definition ----------------------------------------------------------
    # shared methods
    module SharedMethods
      def build_payload(attrs, relationships = {})
        # attrs are essential
        raise ApiRequestError, 'Attributes are blank.' if attrs.blank?

        payload = { "data": { "type": entity_path } }
        payload[:data][:attributes] = attrs

        # relationships are optional
        return payload.to_json if relationships.blank?

        relationships_hash = build_relationships(relationships)
        payload[:data][:relationships] = relationships_hash

        payload.to_json
      end

      def build_relationships(relationships)
        relationships_array = relationships.map do |k, v| 
          association_info = RELATIONSHIP_PAYLOADS.find { |param| param[:association_id] == k.to_s }
          raise ApiRequestError if association_info.nil?

          { "#{association_info[:relationship]}": { "data": { "type": "#{k.to_s.sub(/_id\z/, '').pluralize}", "id": v } } }
        end

        # merge all the relationships together and convert it to Hash
        relationships_array.reduce({}, :merge)
      end
    end

    # class methods for entities
    module ClassMethods
      include SharedMethods

      # Fetches all entities from the API for the current class.
      #
      # @return [Array] An array containing all entities retrieved from the API.
      #
      # Example: Productive::Project.all
      def all
        retrieve_entities_from_api("#{path}")
      end

      # Finds an entity by its ID from the API.
      #
      # @param id [String, Integer] The ID of the entity to be retrieved from the API.
      # @return [Object, nil] The entity with the specified ID, or nil if not found.
      #
      # Example: Productive::Project.find(123)
      def find(id)
        raise ApiRequestError, 'Entity id is invalid.' if id.nil?
        entities = retrieve_entities_from_api("#{path}/#{id}")

        return nil if entities.empty?
        entities.first
      end

      # Creates a new entity by sending a POST request to the API.
      #
      # @param attrs [Hash] The attributes for the new entity.
      # @param relationships [Hash] (optional) The relationships for the new entity.
      # @return [Object] The newly created entity.
      #
      # Example:
      #   p = Productive::Project.create({name: "create 1", project_type_id: 1}, {company_id: "699400", project_manager_id: "561888", workflow_id: "32544"})
      def create(attrs, relationships = {})
        response = HttpClient.post("#{path}", build_payload(attrs, relationships))
        Parser.handle_response(response, self)
      end

      private

      def path
        config = REQ_PARAMS.find { |param| param[:entity] == self.name }
        raise "Entity config not found: #{self.name}" if config.nil?

        @path ||= config[:path]
      end

      def retrieve_entities_from_api(req_params)
        response = HttpClient.get(req_params)
        Parser.handle_response(response, self)
      end

      def entity_path
        REQ_PARAMS.find { |param| param[:entity] == self.name }[:path]
      end
    end

    # instance methods for entities
    module InstanceMethods
      include HttpClient
      include SharedMethods

      # Updates the entity by sending a PATCH request to the API.
      #
      # @param attrs [Hash] The attributes for updating the entity.
      # @param relationships [Hash] (optional) The relationships for updating the entity.
      # @return [Object] The updated entity.
      #
      # Example:
      #   p = Productive::Project.find(399787)
      #   p.update({name: "update 1"})
      def update(attrs, relationships = {})
        response = HttpClient.patch("#{path}/#{id}", build_payload(attrs, relationships))
        Parser.handle_response(response, self)
      end

      private

      def path
        config = REQ_PARAMS.find { |param| param[:entity] == self.class.name }
        raise "Entity config not found: #{self.class.name}" if config.nil?

        @path ||= config[:path]
      end

      def entity_path
        REQ_PARAMS.find { |param| param[:entity] == self.class.name }[:path]
      end
    end
  end
end