module ProjectsApi
  extend ActiveSupport::Concern

  # optimize: split the class into several by "GET", "POST", etc.
  class Projects
    include SetHeaders
    include SetBody

    attr_accessor :api_endpoint
    attr_accessor :data
    attr_accessor :errors

    # the caller can change the endpoint as needed when creating an instance
    def initialize api_endpoint = "https://api.productive.io/api/v2/projects"
      @api_endpoint = api_endpoint
    end

    def get_projects
      response = HTTParty.get("https://api.productive.io/api/v2/projects", :headers => set_auth_headers)
      @data = response.parsed_response["data"]
      # puts @result

      @data.each do |hash|
        puts hash["id"] + " " + hash["type"]
      end
    end

    def get_project_by_id id
      url = "https://api.productive.io/api/v2/projects/#{id}"
      # puts url

      response = HTTParty.get(url, :headers => set_auth_headers)
      @errors = response.parsed_response["errors"]
      pp @errors
    end

    def create_project
      # options = { :headers => set_body_headers, :body => set_bodys }
      options = { :headers => set_body_headers, :body => set_body.to_json }
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

    def update_project

    end

    def archive_project

    end

    def restore_project

    end

    def delete_project

    end

    def copy_project

    end

    def change_workflow_project

    end

    def map_to_workflow_project

    end

  end
end