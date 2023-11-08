module BaseClass
  def get_client
    raise ApiRequestError, "Entity is nil" if self.name.nil? 
    entity = self.name.downcase.pluralize
    client = ProductiveClient.new(entity)
  end
end