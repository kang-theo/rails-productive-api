# require 'net/http'
# require 'uri'
class Project < ProductiveApi::Base
    attr_accessor :uri
    attr_accessor :data
    attr_accessor :errors
    # attr_accessor :connection
  
    #TODO: use model accessing ways to abstract the api

    # the caller can change the endpoint as needed when creating an instance
    def initialize 
      @uri = super.model_base_uri + "/projects"
      # @connection = HttpConnection.new("")
    end

    # should be class method, because it is related to all the records
    def self.all 
      response = HTTParty.patch(set_uri("all", nil))
      @data = response.parsed_response["data"]
      @data.each do |hash|
        # puts hash["id"] + " " + hash["type"]
      puts "[project info]:--------------------"
      puts hash
      end
    end

    def one (id)
      response = HTTParty.patch(set_uri(nil, id))
      @data = response.parsed_response["data"]
      pp @data
    end

    def self.create
      response = http_post(set_uri("create", nil), set_options(create_body))
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
      response = HTTParty.patch(set_uri("update", id), set_options(update_body))
      pp response
    end

    def archive (id)
      response = HTTParty.patch(set_uri("archive", id), set_options(archive_body))
      pp response
    end

    def restore (id)
      response = HTTParty.patch(set_uri("restore", id), set_options(restore_body))
      pp response
    end

    def delete (id)
      response = HTTParty.delete(set_uri("delete", id), set_options(delete_body))
      pp response
    end

    def copy (id)
      response = http_post(set_uri("copy", id), set_options(copy_body))
      @data = response.parsed_response["data"]
      pp @data
    end

    # methods below are related to both workflow and project, should not be here, 
    # which will influence the class abstraction
    def change_workflow_project

    end

    def map_to_workflow_project

    end

  end