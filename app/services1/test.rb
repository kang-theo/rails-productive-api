class Entity
  def initialize(data)
    validate_data(data)
    @id = data['id']
    @type = data['type']
    initialize_attributes(data['attributes'])
  end

  def initialize_attributes(attributes)
    validate_attributes(attributes)
    attributes.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  private

  def validate_data(data)
    raise ArgumentError, 'Data must be a Hash' unless data.is_a?(Hash) && !data.blank?
    raise ArgumentError, 'Data must contain id and type keys' unless data.key?('id') && data.key?('type')
  end

  def validate_attributes(attributes)
    raise ArgumentError, 'Attributes must be a Hash' unless attributes.is_a?(Hash)
  end
end

class Project < Entity
  attr_accessor :organization, :company, :project_manager, :last_actor, :workflow, :custom_field_people,
                :memberships, :template_object

  def initialize(data)
    super
    initialize_relationships(data['relationships'])
  end

  def initialize_relationships(relationships)
    validate_relationships(relationships)
    @organization = Organization.new(relationships['organization']['data']) if relationships['organization']['data']
    @company = Company.new(relationships['company']['data']) if relationships['company']['data']
    @project_manager = Person.new(relationships['project_manager']['data']) if relationships['project_manager']['data']
    @last_actor = Person.new(relationships['last_actor']['data']) if relationships['last_actor']['data']
    @workflow = Workflow.new(relationships['workflow']['data']) if relationships['workflow']['data']
    @custom_field_people = initialize_entities(Person, relationships['custom_field_people']['data']) if relationships['custom_field_people']['data']
    @memberships = initialize_entities(Membership, relationships['memberships']['data']) if relationships['memberships']['data']
    @template_object = TemplateObject.new(relationships['template_object']['data']) if relationships['template_object']['data']
  end

  private

  def validate_relationships(relationships)
    raise ArgumentError, 'Relationships must be a Hash' unless relationships.is_a?(Hash)
  end

  def validate_entities(entity_class, data_array)
    raise ArgumentError, "#{entity_class} must be an array" unless data_array.is_a?(Array)
  end

  def initialize_entities(entity_class, data_array)
    validate_entities(entity_class, data_array)
    data_array.map { |item| entity_class.new(item) }
  end
end

# Validation for other classes (Organization, Company, etc.) can be similarly added.
