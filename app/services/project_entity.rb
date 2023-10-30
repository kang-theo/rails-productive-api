class ProjectEntity < ProductiveEntity
  attr_accessor :id, :type, :attributes, :relationships

  def initialize(data)
    @id = data['id']
    @type = data['type']
    @attributes = data['attributes']
    @relationships = data['relationships']
  end

  # Helper methods to access specific attributes
  def name
    attributes['name']
  end

  def number
    attributes['number']
  end

  def project_number
    attributes['project_number']
  end

  def project_type_id
    attributes['project_type_id']
  end

  def project_color_id
    attributes['project_color_id']
  end

  def last_activity_at
    attributes['last_activity_at']
  end

  def public_access
    attributes['public_access']
  end

  def time_on_tasks
    attributes['time_on_tasks']
  end

  def tag_colors
    attributes['tag_colors']
  end

  def archived_at
    attributes['archived_at']
  end

  def created_at
    attributes['created_at']
  end

  def template
    attributes['template']
  end

  def budget_closing_date
    attributes['budget_closing_date']
  end

  def needs_invoicing
    attributes['needs_invoicing']
  end

  def custom_fields
    attributes['custom_fields']
  end

  def task_custom_fields_ids
    attributes['task_custom_fields_ids']
  end

  def sample_data
    attributes['sample_data']
  end

  def organization_id
    relationships['organization']['data']['id']
  end

  def organization_type
    relationships['organization']['data']['type']
  end

  def company_id
    relationships['company']['data']['id']
  end

  def company_type
    relationships['company']['data']['type']
  end

  def project_manager_id
    relationships['project_manager']['data']['id']
  end

  def project_manager_type
    relationships['project_manager']['data']['type']
  end

  def last_actor_id
    relationships['last_actor']['data']['id']
  end

  def workflow_id
    relationships['workflow']['data']['id']
  end

  def workflow_type
    relationships['workflow']['data']['type']
  end

  def custom_field_people
    relationships['custom_field_people']['data']
  end

  def memberships
    relationships['memberships']['data']
  end

  def template_object
    relationships['template_object']['data']
  end
end