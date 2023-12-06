require 'rails_helper'

RSpec.describe Productive::Parser, type: :request do
# =begin
  describe '.parse_response' do
    context 'when the block execution is successful' do
      let(:data){ File.read('./spec/fixtures/response.json') }

      it 'does not raise an error' do
        expect do
          Productive::Parser.parse_response do
            JSON.parse(data).dig('data')
          end
        end.to_not raise_error
      end
    end

    context 'when the block execution raises JSON::ParserError' do
      let(:data) { File.read('./spec/fixtures/response.xml') } 

      it 'rescues the error and logs it' do
        allow(Rails.logger).to receive(:error)

        response_data = Productive::Parser.parse_response do
          JSON.parse(data).dig('data')
        end

        expect(Rails.logger).to have_received(:error).with(/JSON::ParserError: unexpected token/)
        expect(response_data).to eq({ error: 'JSON::ParserError', status: :bad_response })
      end
    end
  end

  describe '.parse_attributes' do
    context 'parse attributes from response' do
      it '' do
        data_hash = {"id"=>"399787", "type"=>"projects", "attributes"=>{"name"=>"Update project", "number"=>"1", "project_number"=>"1", "project_type_id"=>1, "project_color_id"=>9, "last_activity_at"=>"2023-12-05T05:40:54.000+01:00", "public_access"=>true, "time_on_tasks"=>false, "tag_colors"=>{}, "archived_at"=>nil, "created_at"=>"2023-11-28T01:04:43.344+01:00", "template"=>false, "needs_invoicing"=>false, "sample_data"=>true}, "relationships"=>{"organization"=>{"data"=>{"type"=>"organizations", "id"=>"31810"}}, "company"=>{"data"=>{"type"=>"companies", "id"=>"699398"}}, "project_manager"=>{"data"=>{"type"=>"people", "id"=>"561888"}}, "last_actor"=>{"data"=>{"type"=>"people", "id"=>"561886"}}, "workflow"=>{"data"=>{"type"=>"workflows", "id"=>"32544"}}, "memberships"=>{"data"=>[{"type"=>"memberships", "id"=>"6368022"}, {"type"=>"memberships", "id"=>"6368023"}, {"type"=>"memberships", "id"=>"6368024"}, {"type"=>"memberships", "id"=>"6450128"}]}}}
        association_info = {"organization"=>"31810", "company"=>"699398", "project_manager"=>"561888", "last_actor"=>"561886", "workflow"=>"32544", "memberships"=>["6368022", "6368023", "6368024", "6450128"]}
        attributes = Productive::Parser.parse_attributes(data_hash, association_info)

        expect(attributes).to eq({"name"=>"Update project", "number"=>"1", "project_number"=>"1", "project_type_id"=>1, "project_color_id"=>9, "last_activity_at"=>"2023-12-05T05:40:54.000+01:00", "public_access"=>true, "time_on_tasks"=>false, "tag_colors"=>{}, "archived_at"=>nil, "created_at"=>"2023-11-28T01:04:43.344+01:00", "template"=>false, "needs_invoicing"=>false, "sample_data"=>true, "id"=>"399787", "organization_id"=>"31810", "company_id"=>"699398", "project_manager_id"=>"561888", "last_actor_id"=>"561886", "workflow_id"=>"32544", "membership_ids"=>["6368022", "6368023", "6368024", "6450128"]})
      end
    end
  end

  describe '.parse_associations_info' do
    context 'data with valid relationships' do
      it 'parses the association info from the response' do
        data_hash = {"id"=>"399787", "type"=>"projects", "attributes"=>{"name"=>"Update project", "number"=>"1", "project_number"=>"1", "project_type_id"=>1, "project_color_id"=>9, "last_activity_at"=>"2023-12-05T05:40:54.000+01:00", "public_access"=>true, "time_on_tasks"=>false, "tag_colors"=>{}, "archived_at"=>nil, "created_at"=>"2023-11-28T01:04:43.344+01:00", "template"=>false, "needs_invoicing"=>false, "sample_data"=>true}, "relationships"=>{"organization"=>{"data"=>{"type"=>"organizations", "id"=>"31810"}}, "company"=>{"data"=>{"type"=>"companies", "id"=>"699398"}}, "project_manager"=>{"data"=>{"type"=>"people", "id"=>"561888"}}, "last_actor"=>{"data"=>{"type"=>"people", "id"=>"561886"}}, "workflow"=>{"data"=>{"type"=>"workflows", "id"=>"32544"}}, "memberships"=>{"data"=>[{"type"=>"memberships", "id"=>"6368022"}, {"type"=>"memberships", "id"=>"6368023"}, {"type"=>"memberships", "id"=>"6368024"}, {"type"=>"memberships", "id"=>"6450128"}]}}}
        association_info = Productive::Parser.parse_associations_info(data_hash)
        
        expect(association_info['organization']).to eq("31810") 
        expect(association_info['company']).to eq("699398") 
        expect(association_info['workflow']).to eq("32544") 
        expect(association_info['memberships']).to eq(["6368022", "6368023", "6368024", "6450128"]) 
      end
    end

    context 'data of a relationship last_actor is nil' do
      it 'parses the association info from the response' do
        data_hash = {"id"=>"399787", "type"=>"projects", "attributes"=>{"name"=>"Update project", "number"=>"1", "project_number"=>"1", "project_type_id"=>1, "project_color_id"=>9, "last_activity_at"=>"2023-12-05T05:40:54.000+01:00", "public_access"=>true, "time_on_tasks"=>false, "tag_colors"=>{}, "archived_at"=>nil, "created_at"=>"2023-11-28T01:04:43.344+01:00", "template"=>false, "budget_closing_date"=>nil, "needs_invoicing"=>false, "custom_fields"=>nil, "task_custom_fields_ids"=>nil, "sample_data"=>true}, "relationships"=>{"organization"=>{"data"=>{"type"=>"organizations", "id"=>"31810"}}, "company"=>{"data"=>{"type"=>"companies", "id"=>"699398"}}, "project_manager"=>{"data"=>{"type"=>"people", "id"=>"561888"}}, "last_actor"=>{"data"=>nil}, "workflow"=>{"data"=>{"type"=>"workflows", "id"=>"32544"}}, "custom_field_people"=>{"data"=>[]}, "memberships"=>{"data"=>[{"type"=>"memberships", "id"=>"6368022"}, {"type"=>"memberships", "id"=>"6368023"}, {"type"=>"memberships", "id"=>"6368024"}, {"type"=>"memberships", "id"=>"6450128"}]}, "template_object"=>{"data"=>nil}}}
        association_info = Productive::Parser.parse_associations_info(data_hash)
        
        expect(association_info).not_to have_key("last_actor") 
      end
    end

    context 'data of a relationship memberships is empty' do
      it 'parses the association info from the response' do
        data_hash = {"id"=>"399787", "type"=>"projects", "attributes"=>{"name"=>"Update project", "number"=>"1", "project_number"=>"1", "project_type_id"=>1, "project_color_id"=>9, "last_activity_at"=>"2023-12-05T05:40:54.000+01:00", "public_access"=>true, "time_on_tasks"=>false, "tag_colors"=>{}, "archived_at"=>nil, "created_at"=>"2023-11-28T01:04:43.344+01:00", "template"=>false, "budget_closing_date"=>nil, "needs_invoicing"=>false, "custom_fields"=>nil, "task_custom_fields_ids"=>nil, "sample_data"=>true}, "relationships"=>{"organization"=>{"data"=>{"type"=>"organizations", "id"=>"31810"}}, "company"=>{"data"=>{"type"=>"companies", "id"=>"699398"}}, "project_manager"=>{"data"=>{"type"=>"people", "id"=>"561888"}}, "last_actor"=>{"data"=>{"type"=>"people", "id"=>"561886"}}, "workflow"=>{"data"=>{"type"=>"workflows", "id"=>"32544"}}, "custom_field_people"=>{"data"=>[]}, "memberships"=>{"data"=>[]}, "template_object"=>{"data"=>nil}}}
        association_info = Productive::Parser.parse_associations_info(data_hash)
        
        expect(association_info).not_to have_key("memberships") 
      end
    end
  end
# =end
end