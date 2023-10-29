require 'json'
class Productive
  include Base

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
    begin
      response =  HTTParty.post(set_uri("create", nil, @@uri), set_options(create_body))
      # should be successful, but ...
      # @errors = response.parsed_response["errors"]
      # pp @errors
      pp response
      # @data = response.parsed_response["data"]
      # # puts @result
      # @data.each do |hash|
      #   puts hash["id"] + " " + hash["type"]
      # end
    rescue HTTParty::Error
      # Handle HTTParty-specific errors here
      puts "HTTParty error occurred"
    rescue StandardError => e
      # Handle other errors (e.g., network issues, parsing errors) here
      puts "An error occurred: #{e.message}"
    end
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
      # HttpClient.get("#{HOST}/#{self.class.to_s.downcase().pluralize()}", {'headers' => {'Content-Type' =>  'application/vnd.api+json; ext=bulk'}})
      # raise HttpClient::HttpError.new("E001", "HTTP Error")
    rescue HttpClient::HttpError => e
      puts "Exception caught: #{e.message}"
    end
  end

  def self.get_response_with_id(method, id)
    path = case method.to_s
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