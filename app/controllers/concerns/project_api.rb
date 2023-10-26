# require 'net/http'
# require 'uri'
module ProjectApi
  extend ActiveSupport::Concern

  # optimize: split the class into several by "GET", "POST", etc.
  class Project
    include SetHeaders
    include SetBody

    attr_accessor :api_endpoint
    attr_accessor :data
    attr_accessor :errors
    # attr_accessor :connection
  
    #TODO: use model accessing ways to abstract the api

    # the caller can change the endpoint as needed when creating an instance
    def initialize api_endpoint = "https://api.productive.io/api/v2/projects"
      @api_endpoint = api_endpoint
      # @connection = HttpConnection.new("")
    end

    # should be class method, because it is related to all the records
    def self.all 
      response = HTTParty.get("https://api.productive.io/api/v2/projects", :headers => set_auth_headers)
      @data = response.parsed_response["data"]
      @data.each do |hash|
        # puts hash["id"] + " " + hash["type"]
      puts "[project info]:--------------------"
      puts hash
      end

      # uri = URI.parse(@api_endpoint)
      # http = Net::HTTP.new(uri.host, uri.port)

      # puts uri.request_uri
      # request = Net::HTTP::Get.new("https://api.productive.io/api/v2/projects")
      # request["X-Auth-Token"] = "0b74561b-0d18-4996-bb69-7ffa59a40681"
      # request["X-Organization-Id"] = "30897"
      # request["Content-Type"] = "application/vnd.api+json"

      # response = http.request(request)
      # puts response.code
      # puts response.body

      # response = connection.get("/projects", set_auth_headers.to_json)
      # response = Net::HTTP.get('www.baidu.com', '/index.html')
      # puts response

    end

    def one (id)
      url = "https://api.productive.io/api/v2/projects/#{id}"
      # puts url

      # code below appear in multiple places, should be abstracted
      response = HTTParty.get(url, :headers => set_auth_headers)
      @errors = response.parsed_response["errors"]
      pp @errors
    end

    def create
      options = { :headers => set_body_headers, :body => set_body(create_body).to_json }
      puts options
      response = HTTParty.post(@api_endpoint, options)
      # should be successful, but ...
      # @errors = response.parsed_response["errors"]
      # pp @errors

      pp response
      # @data = response.parsed_response["data"]
      # # puts @result
      # @data.each do |hash|
      #   puts hash["id"] + " " + hash["type"]
      # end
    end

    # do not follow all the apis provided, try to abstract them into several ones used in reality
    def update (id)
      url = "https://api.productive.io/api/v2/projects/#{id}"
      options = { :headers => set_body_headers, :body => set_body(update_body).to_json }

      response = HTTParty.patch(url, options)
      pp response
    end

    def archive (id)
      url = "https://api.productive.io/api/v2/projects/#{id}/archive"
    
      options = { :headers => set_body_headers, :body => set_body(archive_body).to_json }

      response = HTTParty.patch(url, options)
      pp response


    end

    def restore

    end

    def delete

    end

    def copy

    end

    # methods below are related to both workflow and project, should not be here, 
    # which will influence the class abstraction
    def change_workflow_project

    end

    def map_to_workflow_project

    end

    # def get_companies

    # end

  end
end