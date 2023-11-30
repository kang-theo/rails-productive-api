# frozen_string_literal: true

module Productive
  module Common
    # const definition -----------------------------------------------------------
    # TODO： 从 response 中应该可以获取所有需要的信息，不需要把这些信息再存到表里
    # req_path: the same with relationship_type, relationship_key: the association_inf[key], relationship_type: the type in the relationship, relationship_id: the association_id, the id in the relationship
    ENTITY_RELATIONSHIP = [
      { entity: 'Productive::Project',      req_path: 'projects',      relationship_key: 'project',         relationship_type: 'projects',      relationship_id: 'project_id',        },
      { entity: 'Productive::Company',      req_path: 'companies',     relationship_key: 'company',         relationship_type: 'companies',     relationship_id: 'company_id',        },
      { entity: 'Productive::Organization', req_path: 'organizations', relationship_key: 'organization',    relationship_type: 'organizations', relationship_id: 'organization_id',   },
      { entity: 'Productive::Membership',   req_path: 'memberships',   relationship_key: 'memberships',     relationship_type: 'memberships',   relationship_id: 'membership_id',     },
      { entity: 'Productive::Workflow',     req_path: 'workflows',     relationship_key: 'workflow',        relationship_type: 'workflows',     relationship_id: 'workflow_id',       },
      { entity: 'Productive::Person',       req_path: 'people',        relationship_key: 'person',          relationship_type: 'people',        relationship_id: 'person_id',         },
      { entity: 'Productive::Person',       req_path: 'people',        relationship_key: 'project_manager', relationship_type: 'people',        relationship_id: 'project_manager_id',},
      { entity: 'Productive::Person',       req_path: 'people',        relationship_key: 'last_actor',      relationship_type: 'people',        relationship_id: 'last_actor_id'      },
      { entity: 'Productive::Person',       req_path: 'people',        relationship_key: 'owner',           relationship_type: 'people',        relationship_id: 'owner_id',          }
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
        entity_name = respond_to?(:name) ? name : self.class.name

        config = ENTITY_RELATIONSHIP.find { |param| param[:entity] == entity_name }
        raise ApiRequestError, "Entity config not found: #{entity_name}" if config.nil?

        path ||= config[:req_path]
      end

      # TODO: 不要总是传递参数，最好的就是没有参数，使用更加面向对象的方式
      def build_payload(attrs, relationships = {})
        # attrs are essential
        raise ApiRequestError, 'Attributes are blank.' if attrs.blank?

        payload = {
          "data": {
            "type": path,
            "attributes": attrs
          }
        }

        # relationships are optional
        return payload.to_json if relationships.blank?

        relationships_hash = build_relationships(relationships)
        payload[:data][:relationships] = relationships_hash

        payload.to_json
      end

      def build_relationships(relationships)
        relationships_array = relationships.map do |k, v| 
          association_info = ENTITY_RELATIONSHIP.find { |param| param[:relationship_id] == k.to_s }
          raise ApiRequestError if association_info.nil?

          # TODO: membership 是一个数组，需要考虑到这种情况
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
      # TODO: 当写测试时，需要考虑所有的参数，这就是尽量减少传递参数的原因
      def create(attrs, relationships = {})
        response = HttpClient.post("#{path}", build_payload(attrs, relationships))
        Parser.handle_response(response, self)
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
        # TODO: 使用更加有意义的方法，比如：update, patch_attributes, etc.
        response = HttpClient.patch("#{path}/#{id}", build_payload(attrs, relationships))
        Parser.handle_response(response, self)
      end
    end
  end
end