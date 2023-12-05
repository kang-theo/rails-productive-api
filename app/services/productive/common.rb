# frozen_string_literal: true

module Productive
  module Common
    # const definition -----------------------------------------------------------
    # TODO: get from the response, avoid redundancy
    # req_path: the same with relationship_type, relationship_key: the association_inf[key], relationship_type: the type in the relationship, relationship_id: the association_id, the id in the relationship
    ENTITY_RELATIONSHIP = [
      { entity: 'Productive::Project',      req_path: 'projects',      relationship_key: 'project',         relationship_type: 'projects',      relationship_id: 'project_id'        },
      { entity: 'Productive::Company',      req_path: 'companies',     relationship_key: 'company',         relationship_type: 'companies',     relationship_id: 'company_id'        },
      { entity: 'Productive::Organization', req_path: 'organizations', relationship_key: 'organization',    relationship_type: 'organizations', relationship_id: 'organization_id'   },
      { entity: 'Productive::Membership',   req_path: 'memberships',   relationship_key: 'memberships',     relationship_type: 'memberships',   relationship_id: 'membership_id'     },
      { entity: 'Productive::Workflow',     req_path: 'workflows',     relationship_key: 'workflow',        relationship_type: 'workflows',     relationship_id: 'workflow_id'       },
      { entity: 'Productive::Person',       req_path: 'people',        relationship_key: 'person',          relationship_type: 'people',        relationship_id: 'person_id'         },
      { entity: 'Productive::Person',       req_path: 'people',        relationship_key: 'project_manager', relationship_type: 'people',        relationship_id: 'project_manager_id'},
      { entity: 'Productive::Person',       req_path: 'people',        relationship_key: 'last_actor',      relationship_type: 'people',        relationship_id: 'last_actor_id'     },
      { entity: 'Productive::Person',       req_path: 'people',        relationship_key: 'owner',           relationship_type: 'people',        relationship_id: 'owner_id'          }
    ]

    # module inclusion -----------------------------------------------------------
    def Common.included(base) 
      base.extend ClassMethods
      base.include InstanceMethods
    end

    
    # module definition ----------------------------------------------------------
    # shared methods
    module SharedMethods
      def path
        entity_name = self.class != Class ? self.class.name : name

        config = ENTITY_RELATIONSHIP.find { |param| param[:entity] == entity_name }
        raise ApiRequestError, "Entity config not found: #{entity_name}" if config.nil?

        path ||= config[:req_path]
      end

      def foreign_key?(attr)
        # TODO: refactor the method
        !attr.start_with?("project") && (attr.end_with?("_id") || attr.end_with?("_ids"))
      end

      def track_change(attr, old_value, new_value)
        changes
        @changes[attr] = new_value if old_value != new_value
      end

      def build_payload
        changed_attrs
        changed_relationships

        changes.each do |k, v|
          foreign_key?(k) ? changed_relationships[k] = v : changed_attrs[k] = v
        end

        # attrs are essential
        raise ApiRequestError, 'Attributes are blank.' if changed_attrs.blank?

        payload = {
          "data": {
            "type": path,
            "attributes": changed_attrs
          }
        }

        # relationships are optional
        return payload.to_json if changed_relationships.blank?

        relationships_hash = build_relationships
        payload[:data][:relationships] = relationships_hash

        payload.to_json
      end

      def build_relationships
        relationships_array = changed_relationships.map do |k, v| 
          association_info = ENTITY_RELATIONSHIP.find { |param| param[:relationship_id] == k.to_s }
          raise ApiRequestError if association_info.nil?

          # TODO: membership is an array
          { "#{association_info[:relationship_key]}": { "data": { "type": "#{k.to_s.sub(/_id\z/, '').pluralize}", "id": v } } }
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
      # Example: Productive::Project.find(399787)
      def find(id)
        raise ApiRequestError, 'Entity id is invalid.' if id.nil?
        entities = retrieve_entities_from_api("#{path}/#{id}")

        return nil if entities.empty?
        entities.first
      end

      private

      def retrieve_entities_from_api(req_params)
        response = HttpClient.get(req_params)
        Parser.handle_response(response, self)
      end
    end

    # instance methods for entities
    module InstanceMethods
      include HttpClient
      include SharedMethods

      def new?
        !self.respond_to?(:id)
      end

      def handle_request
        case new? ? :create : :update
        when :create
          HttpClient.post("#{path}", build_payload)
        when :update
          HttpClient.patch("#{path}/#{id}", build_payload)
        else
          raise ApiRequestError, 'Undefined action.'
        end
      end

      # TODO: need to validate the required uri parameters
      # Refer to active-record style
      # Example: create
      #   p = Productive::Project.new
      #   p.name = "create 1"
      #   p.project_type_id = 1
      #   p.company_id = "699400"
      #   p.project_manager_id = "561888"
      #   p.workflow_id = "32544"
      #   p.save
      # Example: update
      #   p = Productive::Project.find(399787)
      #   p.name = "update 1"
      #   p.project_type_id = 1
      #   p.project_manager_id="561888"
      #   p.company_id="699400"
      #   p.workflow_id="31544"
      #   p.save
      def save
        response = handle_request

        return self if response.success?
        nil
      end
    end
  end
end