require 'json'
class Productive
  include Base
  extend Base::ReqParamBuilder

  # https://api.productive.io/api/v2/projects
  def self.all
    response = get_response(__method__)
    print_all(response)
  end

  # Project.find(id)
  def self.find(id)
    response = get_response_with_id(__method__, id)
    print(response)
  end

  def self.create
    uri= "#{HOST}/#{self.name.downcase().pluralize()}"
    response =  HttpClient.post(uri, set_payload(), set_option_headers())
    # JSON.parse(response)["data"]
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
 
  def self.get_response(method)
    if method.to_s == "copy"
      path = method.to_s
    else
      path = ""
    end

    uri= "#{HOST}/#{self.name.downcase().pluralize()}" + path
    begin
      response = HttpClient.get(uri)
      JSON.parse(response)["data"]
      # raise HttpClient::HttpError.new("E001", "HTTP Error")
    rescue HttpClient::HttpError => e
      puts "Exception caught: #{e.message}"
    end
  end

  def self.get_response_with_id(method, id)
    path = case method.to_s
    # id is bind to the instances
    when "archive"
      "/#{id}/archive"
    when "restore"
      "/#{id}/restore"
    else
      "/#{id}"
    end

    uri= "#{HOST}/#{self.name.downcase().pluralize()}" + path

    begin
      response = HttpClient.get(uri)
      JSON.parse(response)["data"]
    rescue HttpClient::HttpError => e
      puts "Exception caught: #{e.message}"
    end
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