require 'rails_helper'

RSpec.describe Productive::Project, type: :model do
  # describe '#some_method' do
  #   context 'context of test' do
  #     it 'returns the expected result' do
  #       # Create any necessary test data or mocks

  #       # Call the method being tested

  #       # Assert the expected result
  #     end
  #   end
  # end

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
    end
  end

  describe '.find' do
    it 'sends a GET request for a specific entity' do
    end
  end

  # TODO: see if need to test other methods in Common like track_change, path, foreign_key?, build_payload, build_relationships, archive, copy, delete, restore
end