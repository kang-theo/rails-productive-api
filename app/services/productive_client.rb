class ProductiveClient
  include Base
  extend Base::ReqParamBuilder

  def self.all
    response = http_get(__method__)
    project_data = JSON.parse(ActiveSupport::JSON.encode(response))
    projects_hash = Hash.new
    project_data.each do |datum|
      project = ProjectEntity.new(datum)
      projects_hash[project.name] = project
    end
    return projects_hash
  end

  def self.find(id)
    response = http_get(__method__, id)
    puts response
    project_data = JSON.parse(ActiveSupport::JSON.encode(response))

    puts project_data
    # test create accessors dynamically
    json_data = project_data
    project_entity = ProjectEntity.new(json_data)
    puts "1------"
    puts project_entity.type
    puts project_entity.id
    puts project_entity.attributes.class
    puts project_entity.attributes.data["name"]
    puts project_entity.attributes.data.name
    puts project_entity.attributes.organization.class
    puts project_entity.attributes.organization.data.type
    puts project_entity.attributes.id
    puts project_entity.organization.type
    puts project_entity.memberships.first.type
    
    # project = ProjectEntity.new(project_data) 
  end

  # query according to project name
  def self.where(condition)
    projects = all()
    condition.each do |key, value| 
      puts key
      puts value
      # return projects[condition[:name]]
      return projects[value]
    end
  end

  # TODO: create and update should be instance method, new and save
  def self.create
    response = http_post(__method__, set_payload(), set_option_headers())
  end

  private

  def self.http_get(method, id="")
    uri = uri_generator(method, id)
    http_exception_handler(uri) {|uri| HttpClient.get(uri)}
  end

  def self.http_post(method, payload, option_headers, path="")
    uri = uri_generator(method) 
    http_exception_handler(uri, payload, option_headers) {|u, p, o| HttpClient.post(u, p, o)}
  end

  def self.http_patch(method, payload, option_headers, id="")
    uri= uri_generator(method, id)
    http_exception_handler(uri, payload, option_headers) {|u, p, o| HttpClient.patch(u, p, o)}
  end

  def self.http_delete(id="")
    uri= uri_generator(method, id)
    http_exception_handler(uri) {|uri| HttpClient.delete(uri)}
  end
  
  def self.http_exception_handler(uri, payload={}, option_headers={})
    begin
      response = yield(uri, payload, option_headers)
      # JSON.parse(response)["data"]
      # create accessors dynamically according to the json data
      puts "2-----"
      puts JSON.parse(response)["data"]
      JSON.parse(response)["data"]
    rescue HttpClient::HttpError => e
      puts "Exception caught: #{e.message}"
    end
  end

  def self.uri_generator(method, id="")
    str_method = method.to_s

    path = case str_method
    when "archive", "restore"
      "/#{id}/" + str_method
    when "copy", "change_workflow", "map_to_workflow"
      str_method
    when "find", "delete", "update"
      "/#{id}"
    else
      ""
    end

    uri= "#{HOST}/#{self.name.split(/(?=[A-Z])/).first.downcase().pluralize()}" + path
  end

  def self.print_all(data)
      data.each do |hash|
      puts "\n[projects info]: #{hash["attributes"]["name"]}"
      puts hash
    end
  end

  def self.print(data)
    puts "\n[project info]: #{data["attributes"]["name"]}"
    puts data
  end
  
end