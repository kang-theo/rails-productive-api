module BaseClass
  def get_client
    raise ApiRequestError, "Entity is nil" if self.name.nil? 
    entity = self.name.downcase.pluralize
    client = ProductiveClient.new(entity)
  end

  # options: {entity: "", id: nil, action: "", data: {}}
  # usage: Project.all, Company.all
  def all
    client = get_client
    client.get(Hash[entity: client.entity]) unless client.nil?
  end

  def find(id)
    client = get_client
    entity = client.get(Hash[entity: client.entity, id: id]) unless client.nil?
    if entity.is_a?(Array)
      entity.first
    end
  end


end