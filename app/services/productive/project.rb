# frozen_string_literal: true

module Productive
  class Project < Base
    # project has many memberships, memberships has one project, they are one-many relationship, so the memberships should have a foreign key of project_id

    def update(param_attrs, param_relationships)
      # build_attributes
      attr_header = '"attributes": {'
      attr_body = param_attrs.map { |k, v| %Q("#{k}":#{v.inspect}) }.join(',')
      attr_footer = '}'
      attrs = attr_header + attr_body + attr_footer
      # attrs = '"attributes": {' + param_attrs.map { |k, v| %Q("#{k}":#{v.inspect}) }.join(',') + '}'

      # build_relationships
      relationship_header = '"relationships": {'
      relationship_body = param_relationships.map { |k, v| %Q("#{RELATIONSHIP_PAYLOADS.find {|param| param[:association_id] == k.to_s}[:relationship]}": { "data": { "type": "#{k.to_s.sub(/_id\z/, '').pluralize}", "id": #{v.inspect} } }) }.join(',')
      relationship_footer = '}'
      relationships = relationship_header + relationship_body + relationship_footer
      # relationships = '"relationships": {' + param_relationships.map { |k, v| %Q("#{RELATIONSHIP_PAYLOADS.find {|param| param[:association_id] == k.to_sym}}": { "data": { "type": "#{k.to_s.sub(/_id\z/, '').pluralize}", "id": #{v.inspect} } }) }.join(',') + '}'

      # build_payload
      payload = '{ "data": { "type": ' + "#{REQ_PARAMS.find { |param| param[:entity] == self.class.name }[:path]}" + ','+ attrs + ','+ relationships +'} }'
      puts payload

      # response = HttpClient.put("#{path}", payload)
      # Parser.handle_response(response, self)
    end

    # p = Productive::Project.find(314500)
    # p.update({name: "project_test", project_num: "1", project_id: 2}, {company_id: "2134", workflow_id: "650"})
  end
end