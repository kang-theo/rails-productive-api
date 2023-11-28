# frozen_string_literal: true

module Productive
  class Base
    include Common
    include Parser

    def initialize(attributes, association_info)
      raise 'ApiRequestError: attributes is blank' if attributes.blank?
      raise 'ApiRequestError: association_info is blank' if association_info.blank?

      create_accessors(attributes)
      define_associations(association_info)
    end

    # def update(param_attrs, param_relationships)
    #   # build_attributes
    #   attr_header = '"attributes": {'
    #   attr_body = param_attrs.map { |k, v| %Q("#{k}":#{v.inspect}) }.join(',')
    #   attr_footer = '}'
    #   attrs = attr_header + attr_body + attr_footer
    #   # attrs = '"attributes": {' + param_attrs.map { |k, v| %Q("#{k}":#{v.inspect}) }.join(',') + '}'

    #   # build_relationships
    #   relationship_header = '"relationships": {'
    #   relationship_body = param_relationships.map { |k, v| %Q("#{RELATIONSHIP_PAYLOADS.find {|param| param[:association_id] == k.to_s}[:relationship]}": { "data": { "type": "#{k.to_s.sub(/_id\z/, '').pluralize}", "id": #{v.inspect} } }) }.join(',')
    #   relationship_footer = '}'
    #   relationships = relationship_header + relationship_body + relationship_footer
    #   # relationships = '"relationships": {' + param_relationships.map { |k, v| %Q("#{RELATIONSHIP_PAYLOADS.find {|param| param[:association_id] == k.to_sym}}": { "data": { "type": "#{k.to_s.sub(/_id\z/, '').pluralize}", "id": #{v.inspect} } }) }.join(',') + '}'

    #   # build_payload
    #   payload = '{ "data": { "type": ' + "#{REQ_PARAMS.find { |param| param[:entity] == self.class.name }[:path]}" + ','+ attrs + ','+ relationships +'} }'
    #   puts payload

    #   # response = HttpClient.put("#{path}", payload)
    #   # Parser.handle_response(response, self)
    # end

    # p = Productive::Project.find(314500)
    # p.update({name: "project_test", project_num: "1", project_id: 2}, {company_id: "2134", workflow_id: "650"})

    private

    # for instance attributes
    def create_accessors(attributes)
      attributes.each do |key, value|
        instance_variable_set("@#{key}", value)

        class_eval do
          define_method(key) { instance_variable_get("@#{key}") }
          define_method("#{key}=") { |value| instance_variable_set("@#{key}", value) }
        end
      end
    end

    # for associative queries
    def define_associations(association_info)
      association_info.each do |key, value|
        # key: membership, etc
        config = Common::RELATIONSHIPS.find { |relationship| relationship[:type] == key }
        raise ApiRequestError, 'Undefined type.' if config.nil?

        # eg. Membership.find(id)
        klass = "#{config[:entity]}".constantize
        ids = Array(value)

        # define association methods
        class_eval do
          define_method(key.to_sym) { ids.map { |id| klass.find(id) } }
        end
      end
    end
  end
end