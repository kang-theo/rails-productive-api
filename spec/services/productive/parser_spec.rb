require 'rails_helper'

RSpec.describe Productive::ResponseHandler, type: :request do
  describe '#parse_attributes' do
    let(:data) { File.read('./spec/fixtures/normal_response_data.json') }
    let(:association_data) { File.read('./spec/fixtures/association_data.json') }

    it 'parse attributes from response' do
      data_hash = JSON.parse(data)
      handler = Productive::ResponseHandler.new(nil, nil, nil)
      handler.association_info = JSON.parse(association_data)

      # call private method with send
      handler.send(:parse_attributes, data_hash)

      expect(handler.attributes).to eq({ 'name' => 'Update project', 'number' => '1', 'project_number' => '1', 'project_type_id' => 1,
                                 'project_color_id' => 9, 'last_activity_at' => '2023-12-05T05:40:54.000+01:00', 'public_access' => true, 'time_on_tasks' => false, 'tag_colors' => {}, 'archived_at' => nil, 'created_at' => '2023-11-28T01:04:43.344+01:00', 'template' => false, 'needs_invoicing' => false, 'sample_data' => true, 'id' => '399787', 'organization_id' => '31810', 'company_id' => '699398', 'project_manager_id' => '561888', 'last_actor_id' => '561886', 'workflow_id' => '32544', 'membership_ids' => %w[6368022 6368023 6368024 6450128] })
    end
  end

  describe '#parse_associations_info' do
    context 'data with valid relationships' do
      let(:data) { File.read('./spec/fixtures/normal_response_data.json') }

      it 'parses the association info from the response' do
        data_hash = JSON.parse(data)
        handler = Productive::ResponseHandler.new(nil, nil, nil)

        handler.send(:parse_associations_info, data_hash)

        expect(handler.association_info['organization']).to eq('31810')
        expect(handler.association_info['company']).to eq('699398')
        expect(handler.association_info['workflow']).to eq('32544')
        expect(handler.association_info['memberships']).to eq(%w[6368022 6368023 6368024 6450128])
      end
    end

    context 'data of a relationship last_actor is nil' do
      let(:data) { File.read('./spec/fixtures/last_actor_nil_response_data.json') }

      it 'parses the association info from the response' do
        data_hash = JSON.parse(data)
        handler = Productive::ResponseHandler.new(nil, nil, nil)
        handler.send(:parse_associations_info, data_hash)

        expect(handler.association_info).not_to have_key('last_actor')
      end
    end

    context 'data of a relationship memberships is empty' do
      let(:data) { File.read('./spec/fixtures/memberships_empty_response_data.json') }

      it 'parses the association info from the response' do
        data_hash = JSON.parse(data)
        handler = Productive::ResponseHandler.new(nil, nil, nil)
        handler.send(:parse_associations_info, data_hash)

        expect(handler.association_info).not_to have_key('memberships')
      end
    end
  end

  describe '#compute' do
    let(:response) { OpenStruct.new(JSON.parse(File.read('./spec/fixtures/response_with_code.json'))) }
    let(:association_data) { JSON.parse(File.read('./spec/fixtures/association_data.json')) }
    let(:attributes_data) { JSON.parse(File.read('./spec/fixtures/attributes_data.json')) }
    let(:entity_class) { Productive::Project }

    it 'parses response and creates entities' do
      # stub instance method and run blocks to set attributes and association_info which should be done by the stubbed methods
      allow_any_instance_of(Productive::ResponseHandler).to receive(:parse_associations_info) do |instance|
        instance.instance_variable_set(:@association_info, instance.instance_variable_get(:@association_info).merge(association_data))
      end

      allow_any_instance_of(Productive::ResponseHandler).to receive(:parse_attributes) do |instance|
        # instance.instance_variable_set(:@attributes, instance.instance_variable_get(:@attributes).merge(attributes_data))
        instance.instance_variable_set(:@attributes, instance.instance_variable_get(:@attributes).merge(attributes_data))
      end

      handler = Productive::ResponseHandler.new(nil, response, entity_class)

      result = handler.compute
      
      expect(result).to all(be_an_instance_of(entity_class))
    end
  end
end