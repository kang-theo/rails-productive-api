require 'rails_helper'
require 'yaml'
require 'httparty'

RSpec.describe Productive::Project, type: :model do
  describe '#initialize' do
    context 'instantiate a project for creating a new project' do
      let(:attributes){ {name: 'Create project x', project_type_id: 1, project_manager_id: '561888', company_id: '699400', workflow_id: '32544'} }
      let(:association_info){ {'project_manager' => '561888', 'company' => '699400', 'workflow' => '32544'} }

      it 'creates an instance with default attributes' do
        entity = Productive::Project.new
        # getter(create_accessors) and default value
        expect(entity.name).to eq('')
        expect(entity.project_type_id).to be_nil
        expect(entity.project_manager_id).to eq('')
        expect(entity.company_id).to eq('')
        expect(entity.workflow_id).to eq('')
      end

      it 'creates instance with provided attributes' do
        entity = Productive::Project.new(attributes)
        #create_accessors - getter
        expect(entity.name).to eq('Create project x')
        expect(entity.project_type_id).to eq(1)
        expect(entity.project_manager_id).to eq('561888')
        expect(entity.company_id).to eq('699400')
        expect(entity.workflow_id).to eq('32544')

        # setter
        entity.project_type_id = 2
        entity.project_manager_id = '561890'
        expect(entity.project_type_id).to eq(2)
        expect(entity.project_manager_id).to eq('561890')  
      end

      #define_associations
      it 'defines associations' do
        entity = Productive::Project.new(attributes, association_info) 

        expect(entity).to respond_to(:project_manager)
        expect(entity).to respond_to(:company)
        expect(entity).to respond_to(:workflow)
      end
    end

    context 'instantiate a project based on info from the API response' do
      # let(:attributes){ {"name"=>"New project", "number"=>"1", "project_number"=>"1", "project_type_id"=>1, "project_color_id"=>9, "last_activity_at"=>"2023-12-08T06:04:20.000+01:00", "public_access"=>true, "time_on_tasks"=>false, "tag_colors"=>{}, "archived_at"=>nil, "created_at"=>"2023-11-28T01:04:43.344+01:00", "template"=>false, "budget_closing_date"=>nil, "needs_invoicing"=>false, "custom_fields"=>nil, "task_custom_fields_ids"=>nil, "sample_data"=>true, "id"=>"399787", "organization_id"=>"31810", "company_id"=>"699398", "project_manager_id"=>"561888", "last_actor_id"=>"561886", "workflow_id"=>"32544", "membership_ids"=>["6368022", "6368023", "6368024", "6450128"]} }
      # let(:association_info){ {"organization"=>"31810", "company"=>"699398", "project_manager"=>"561888", "last_actor"=>"561886", "workflow"=>"32544", "memberships"=>["6368022", "6368023", "6368024", "6450128"]} }
      all_projects = File.read('./spec/fixtures/all_projects.yaml')
      response = OpenStruct.new(YAML.safe_load(all_projects))

      it 'creates an instance with API response' do
        # expect(Productive::Project).to receive(:new).with(attributes, association_info)
        entities = Productive::Parser.handle_response(response, Productive::Project)
        # entity = Productive::Project.new(attributes, association_info)

        debugger
        expect(entity.name).to eq('New project')
        expect(entity.project_type_id).to eq(2)
        expect(entity.company_id).to eq('699398')
      end

      it 'creates instance with provided attributes' do
        attributes = { name: 'Project X', project_type_id: 1, project_manager_id: '123' }
        entity = Productive::Project.new(attributes)
        expect(entity.name).to eq('Project X')
        expect(entity.project_type_id).to eq(1)
        expect(entity.project_manager_id).to eq('123')
      end
    end
  end

  describe '.all' do
    it 'sends a GET request for all entities' do
      # Mock:
      # 1. [mock] get data as return value
      all_projects = File.read('./spec/fixtures/all_projects.yaml')
      data = OpenStruct.new(YAML.safe_load(all_projects))

      # 2. [stub] intercept requests and return specified fake data; all methods that will be called by .all need to be stubbed
      # stub the HTTParty.get method to return a fake response
      allow(Productive::HttpClient).to receive(:get).and_return(data.body)

      # 3. [mock] for non-active-record model, use build_list instaead of create_list
      projects = FactoryBot.build_list(:project, 5)
      # 4. [stub] stub the handle_response method to return a specific result
      allow(Productive::Parser).to receive(:handle_response).and_return(projects)
      # expect(Productive::Parser).to receive(:handle_response).with(data.body, Productive::Project)

      # Act
      # 5. call the method, when methods above are called, they will be intercepted
      entities = Productive::Project.all
      entity = entities.first

      # Assert
      expect(entity).to be_an_instance_of(Productive::Project)
    end
  end

  describe '.find' do
    it 'sends a GET request for a specific entity with valid id' do
      # Mock
      # just stub it
      allow(Productive::HttpClient).to receive(:get).and_return(nil)

      project = FactoryBot.build_list(:project, 1)
      allow(Productive::Parser).to receive(:handle_response).and_return(project)

      # Act
      entity = Productive::Project.find("any_id")

      # Assert
      expect(entity).to be_an_instance_of(Productive::Project)
    end

    it 'sends a GET request for a specific entity with invalid id' do
      # mock
      # not_found = File.read('./spec/fixtures/404_not_found.json')
      # data = OpenStruct.new(JSON.parse(not_found))
      # allow(Productive::HttpClient).to receive(:get).and_return(data.body)
      allow(Productive::HttpClient).to receive(:get).and_return(nil)

      allow(Productive::Parser).to receive(:handle_response).and_return([])

      entity = Productive::Project.find(-1)
      expect(entity).to be_nil
    end
  end

  describe '#save' do
    context 'POST request with valid attributes' do
      let(:valid_attributes) do
        {
          name: 'New project',
          project_type_id: 1,
          project_manager_id: '561888',
          company_id: '699398',
          workflow_id: '32544'
        }
      end

      let(:response_create) do
        one_project = File.read('./spec/fixtures/create_project.yaml')
        OpenStruct.new(YAML.safe_load(one_project))
      end

      let(:response_update) do
        one_project = File.read('./spec/fixtures/update_project.yaml')
        OpenStruct.new(YAML.safe_load(one_project))
      end

      before do
        # stub
        allow(Productive::HttpClient).to receive(:post).and_return(response_create)
        allow(Productive::HttpClient).to receive(:patch).and_return(response_update)
      end

      it 'creates a new entity' do
        # arrange
        entity = Productive::Project.new
        # like ActiveRecord, implement assign_attributes in plain class to trigger setter methods in order to track changed attributes
        entity.assign_attributes(valid_attributes)

        # act
        result = entity.save

        # assert
        expect(result.id).to eq("399787")
        expect(result.name).to eq("New project")
        expect(result.company_id).to eq("699398")
      end

      it 'updates an existing entity' do
        # arrange
        allow(Productive::HttpClient).to receive(:get).and_return(nil)
        project = FactoryBot.build_list(:project, 1)
        allow(Productive::Parser).to receive(:handle_response).and_return(project)

        entity = Productive::Project.find(399787)
        # update specified attrs and assign them to entity
        entity.assign_attributes(valid_attributes.merge!({name: 'Update project', project_manager_id: '561889'}))

        # act
        result = entity.save

        # assert
        expect(result.id).to eq("399787")
        expect(result.name).to eq("Update project")
        expect(result.project_manager_id ).to eq("561889")
      end

      it 'updates an non-existing entity' do
        allow(Productive::HttpClient).to receive(:patch).and_return(nil)
        allow(Productive::Parser).to receive(:handle_response).and_return([])

        entity = Productive::Project.find(-1)
        expect(entity).to be_nil
      end
    end

    context 'POST request with invalid attributes, lacking required params' do
      let(:invalid_attributes) do
        { 
          name: 'New project',
          project_manager_id: '561888'
        }
      end

      before do
        allow(Productive::HttpClient).to receive(:post).and_return(nil)
        allow(Productive::HttpClient).to receive(:patch).and_return(nil)
      end

      it 'creates a new entity with some required attributes missing' do
        # arrange
        entity = Productive::Project.new
        entity.assign_attributes(invalid_attributes)

        # stub
        allow(Productive::Parser).to receive(:handle_response).and_return([])

        # act
        result = entity.save

        # assert
        expect(result).to be_nil
      end

      it 'updates an existing entity without changing anything' do
        # arrange, handle_response return an array, so build_list is approparate here
        project = FactoryBot.build_list(:project, 1)
        allow(Productive::Parser).to receive(:handle_response).and_return(project)

        entity = Productive::Project.find(399787)

        # assert
        expect{ entity.save }.to raise_error(ApiRequestError, 'Attributes are blank.')
      end
    end
  end

  describe '#inspect' do
    it 'outputs a string representation of an object' do
      entity = Productive::Project.new
      entity.assign_attributes({name: 'New name', company_id: '699401'})

      expect(entity.inspect).not_to include("changed_attrs")
      expect(entity.inspect).not_to include("changed_relationships")
    end
  end

  describe "#archive" do
    before do
      # http request stub
      allow(Productive::HttpClient).to receive(:get).and_return(nil)
      allow(Productive::HttpClient).to receive(:patch).and_return(nil)
    end

    it "archives an existing project" do
      # mock
      unarchived_project = FactoryBot.build(:project)
      allow(Productive::Parser).to receive(:handle_response).and_return([unarchived_project])
      # act
      entity = Productive::Project.find(399787)

      # mock
      archived_project = FactoryBot.build(:project, :with_archived_at)
      allow(Productive::Parser).to receive(:handle_response).and_return([archived_project])
      # act
      result = entity.archive

      # assert
      expect(result.archived_at).to_not be_nil 
    end

    it "archives an non-existing project" do
      allow(Productive::Parser).to receive(:handle_response).and_return([])

      entity = Productive::Project.find(-1)  
      expect(entity).to be_nil 
    end
  end

  describe "#restore" do
    before do
      # http request stub
      allow(Productive::HttpClient).to receive(:get).and_return(nil)
      allow(Productive::HttpClient).to receive(:patch).and_return(nil)
    end

    it "restores an existing project" do
      # mock
      archived_project = FactoryBot.build(:project, :with_archived_at)
      allow(Productive::Parser).to receive(:handle_response).and_return([archived_project])
      # act
      entity = Productive::Project.find(399787)

      # mock
      unarchived_project = FactoryBot.build(:project)
      allow(Productive::Parser).to receive(:handle_response).and_return([unarchived_project])
      # act
      result = entity.restore

      # assert
      expect(result.archived_at).to be_nil 
    end
  end

  # TODO: to be tested after mocking the response
  # describe "#destory" do
  #   it "deletes an existing project" do
  #     entity = Productive::Project.find(399787)  
  #     result = entity.destroy
  #     expect(result).to be_nil 
  #   end
  # end

  # describe ".copy" do
  #   it "replicates an existing project" do
  #     entity = Productive::Project.find(399787)  
  #     result = entity.copy
  #     expect(result).to be_an_instance_of(Productive::Project)
  #   end
  # end
end