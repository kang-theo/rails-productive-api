require 'json'
class Productive
  include Base
  extend Base::ReqParamBuilder

  # https://api.productive.io/api/v2/projects
  def self.all
    response = http_get(__method__)
    print_all(response)
  end

  # Project.find(id)
  def self.find(id)
    response = http_get(__method__, id)
    print(response)
  end

  # should be instance method, new and save
  def self.create
    response = http_post(__method__, set_payload(), set_option_headers())
    pp response
  end

  def update
    begin
      response = HTTParty.patch(Base.set_uri("update", id, @@uri), Base.set_options(update_body))
      pp response
    rescue HTTParty::Error
      puts "HTTParty error occurred"
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end

  private
  # path = case method.to_s
  # # id is bind to the instances
  # when "archive"
  #   "/#{id}/archive"
  # when "restore"
  #   "/#{id}/restore"
  # else
  #   "/#{id}"
  # end

  def self.http_get(method, id="")
    # uri= "#{HOST}/#{self.name.downcase().pluralize()}/#{id}"
    uri = uri_generator(method, id)
    http_exception_handler(uri) {|uri| HttpClient.get(uri)}
  end

  def self.http_post(method, payload, option_headers, path="")
    uri = uri_generator(method) 
    http_exception_handler(uri, payload, option_headers) {|uri, payload, option_headers| HttpClient.post(uri, payload, option_headers)}
  end

  def self.http_patch(id="", method)
    uri= "#{HOST}/#{self.name.downcase().pluralize()}/#{id}"
    http_exception_handler(uri) {|uri| HttpClient.patch(uri)}
  end

  def self.http_delete(id="")
    uri= "#{HOST}/#{self.name.downcase().pluralize()}/#{id}"
    http_exception_handler(uri) {|uri| HttpClient.delete(uri)}
  end
  
  def self.http_exception_handler(uri, payload={}, option_headers={})
    begin
      response = yield(uri, payload, option_headers)
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
    when "find", "delete"
      "/#{id}"
    else
      ""
    end

    uri= "#{HOST}/#{self.name.downcase().pluralize()}" + path
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