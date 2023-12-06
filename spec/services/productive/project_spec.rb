require 'rails_helper'

RSpec.describe Productive::Project, type: :model do
# =begin
  describe '#initialize' do
    context 'instantiate a project for creating a new project' do
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
        attributes = { name: 'Create project x', project_type_id: 1, project_manager_id: '561888', company_id: '699400', workflow_id: '32544'}
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
        attributes = { name: 'Create project x', project_type_id: 1, project_manager_id: '561888', company_id: '699400', workflow_id: '32544'}
        association_info = {'project_manager' => '561888', 'company' => '699400', 'workflow' => '32544'}
        entity = Productive::Project.new(attributes, association_info) 

        expect(entity).to respond_to(:project_manager)
        expect(entity).to respond_to(:company)
        expect(entity).to respond_to(:workflow)
      end
    end

    # TODO: to be tested after mocking response
    # context 'instantiate a project based on info from the API response' do
    #   it 'creates an instance with default attributes' do
    #     entity = Productive::Project.new
    #     expect(entity.name).to eq('')
    #     expect(entity.project_type_id).to be_nil
    #     # ... other default attributes
    #   end

    #   it 'creates instance with provided attributes' do
    #     attributes = { name: 'Project X', project_type_id: 1, project_manager_id: '123' }
    #     entity = Productive::Project.new(attributes)
    #     expect(entity.name).to eq('Project X')
    #     expect(entity.project_type_id).to eq(1)
    #     expect(entity.project_manager_id).to eq('123')
    #   end
    # end
  end

  describe '.all' do
    it 'sends a GET request for all entities' do
      # allow(Productive::HttpClient).to receive(:get).and_return('success')
      # expect(Productive::HttpClient).to receive(:get).with('projects')
      # mock
      # Productive::Project.all
      entities = Productive::Project.all
      entity = entities.first
      expect(entity).to be_an_instance_of(Productive::Project)
    end
  end

  describe '.find' do
    it 'sends a GET request for a specific entity with valid id' do
      # mock
      entity = Productive::Project.find(399787)
      expect(entity).to be_an_instance_of(Productive::Project)
    end

    it 'sends a GET request for a specific entity with invalid id' do
      # mock
      entity = Productive::Project.find(123)
      expect(entity).to be_nil
    end
  end

  describe '#save' do
    context 'POST request with valid attributes' do
      it 'creates a new entity' do
        # arrange
        entity = Productive::Project.new
        entity.name = 'New project'
        entity.project_type_id = 1
        entity.project_manager_id = '561888'
        entity.company_id = '699400'
        entity.workflow_id = '32544'

        # mock
        # allow(Productive::HttpClient).to receive(:post).and_return('success')
        # expect(Productive::HttpClient).to receive(:post).with('projects', instance_of(String))

        # act
        result = entity.save

        # assert
        expect(result).to equal(entity)
        expect(result.name).to eq("New project")
        expect(result.company_id).to eq("699400")
      end

      it 'updates an existing entity' do
        # arrange
        entity = Productive::Project.find(399787)
        entity.name = 'Update project'
        entity.project_type_id = 1
        entity.project_manager_id = '561888'
        entity.company_id = '699400'
        entity.workflow_id = '32544'

        # act
        result = entity.save

        # assert
        expect(result).to equal(entity)
        expect(result.name).to eq("Update project")
        expect(result.project_manager_id ).to eq("561888")
      end

      it 'updates an non-existing entity' do
        entity = Productive::Project.find(123)
        expect(entity).to be_nil
      end
    end

    context 'POST request with invalid attributes, lacking required params' do
      it 'creates a new entity with some required attributes missing' do
        # arrange
        entity = Productive::Project.new
        entity.name = 'New project'
        entity.project_manager_id = '561888'

        # mock: try to mock a HTTParty::Response
        # mocked_response = HTTParty::Response.new(
        #   # code: 200,
        #   # parsed_response: 
        # {
        #   "data": {
        #     "id": 399787,
        #     "type": "projects",
        #     "attributes": {
        #       "name": "Update project",
        #       "number": 1,
        #       "project_number": 1,
        #       "project_type_id": 1,
        #       "project_color_id": 9
        #     },
        #     "relationships": {
        #       "organization": {
        #         "data": {
        #           "type": "organizations",
        #           "id": 31810
        #         }
        #       },
        #       "workflow": {
        #         "data": {
        #           "type": "workflows",
        #           "id": 32544
        #         }
        #       },
        #       "memberships": {
        #         "data": {
        #           "type": "memberships",
        #           "id": 6368022
        #         }
        #       }
        #     }
        #   }
        # }
          #   # parsed_response: {"data":{"id":"399787","type":"projects","attributes":{"name":"Update project"}}}
          #   HTTParty::Request.new(Net::HTTP::Get, '/'), # request object
          #   OpenStruct.new(body: '{"data": {"id": "123", "type": "projects"}}'), # response object
          #   lambda { 'raw_response' }, # response block
          #   200 # status code
          # )
          # allow(Productive::HttpClient).to receive(:post).and_return(mocked_response)
          # expect(Productive::HttpClient).to receive(:post).with('projects', instance_of(String))

          # act
          result = entity.save

        # assert
        expect(result).to be_nil
      end

      it 'updates an existing entity without changing anything' do
        # arrange
        entity = Productive::Project.find(399787)
        entity.name = 'Update project'
        entity.company_id = '699400'

        # assert
        expect{entity.save}.to raise_error(ApiRequestError, 'Attributes are blank.')
      end
    end
  end

  describe '#inspect' do
    it 'outputs a string representation of an object' do
      entity = Productive::Project.new
      entity.name = "New name"
      entity.company_id = "699401"  

      expect(entity.inspect).not_to include("changed_attrs")
      expect(entity.inspect).not_to include("changed_relationships")
    end
  end

  describe "#archive" do
    it "archives an existing project" do
      entity = Productive::Project.find(399787)  
      result = entity.archive
      expect(result.archived_at).to_not be_nil 
    end

    it "archives an non-existing project" do
      entity = Productive::Project.find(123)  
      expect(entity).to be_nil 
    end
  end

  describe "#restore" do
    it "restores an existing project" do
      entity = Productive::Project.find(399787)  
      result = entity.restore
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
# =end
end