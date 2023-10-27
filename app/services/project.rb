# require 'net/http'
# require 'uri'
class Project < ProductiveApi::Base
    attr_accessor :id
    attr_accessor :data
    attr_accessor :errors
    # attr_accessor :connection
  
    # class << self
    #   attr_accessor :uri
    # end

    #TODO: use model accessing ways to abstract the api
    @@uri = ProductiveApi::Base.model_base_uri + "/projects"

    def initialize(id)
      @id = id
    end

    class << self
      # should be class method, because it is related to all the records
      def all 
        begin
          response = HTTParty.get(set_uri("all", nil, @@uri), set_options(nil))
          # if response.code == "200"
          #   puts "Successful" 
          # else
          #   puts error_parse
          # end
          @data = response.parsed_response["data"]
          @data.each do |hash|
            puts "[project info]:--------------------"
            puts hash
          end
        rescue HTTParty::Error
          # Handle HTTParty-specific errors here
          puts "HTTParty error occurred"
        rescue StandardError => e
          # Handle other errors (e.g., network issues, parsing errors) here
          puts "An error occurred: #{e.message}"
        end
      end

      def create
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
    end

    def one
      begin
        response = HTTParty.get(Base.set_uri(nil, id, @@uri), Base.set_options(nil))
        @data = response.parsed_response["data"]
        pp @data
      rescue HTTParty::Error
        puts "HTTParty error occurred"
      rescue StandardError => e
        puts "An error occurred: #{e.message}"
      end
    end

    # do not follow all the apis provided, try to abstract them into several ones used in reality
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

    def archive
      begin
        response = HTTParty.patch(Base.set_uri("archive", id, @@uri), Base.set_options(archive_body))
        pp response
      rescue HTTParty::Error
        puts "HTTParty error occurred"
      rescue StandardError => e
        puts "An error occurred: #{e.message}"
      end
    end

    def restore
      begin
        response = HTTParty.patch(Base.set_uri("restore", id, @@uri), Base.set_options(restore_body))
        pp response
      rescue HTTParty::Error
        puts "HTTParty error occurred"
      rescue StandardError => e
        puts "An error occurred: #{e.message}"
      end
    end

    def delete
      begin
        response = HTTParty.delete(Base.set_uri("delete", id, @@uri), Base.set_options(delete_body))
        pp response
      rescue HTTParty::Error
        puts "HTTParty error occurred"
      rescue StandardError => e
        puts "An error occurred: #{e.message}"
      end
    end

    def copy
      begin
        response =  HTTParty.patch(Base.set_uri("copy", id, @@uri), Base.set_options(copy_body))
        @data = response.parsed_response["data"]
        pp @data
      rescue HTTParty::Error
        puts "HTTParty error occurred"
      rescue StandardError => e
        puts "An error occurred: #{e.message}"
      end
    end

    # methods below are related to both workflow and project, should not be here, 
    # which will influence the class abstraction
    def change_workflow_project

    end

    def map_to_workflow_project

    end

end