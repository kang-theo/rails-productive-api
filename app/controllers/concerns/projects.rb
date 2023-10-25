module Projects
  extend ActiveSupport::Concern

  class ProjectsGet
    include Authentication

    attr_accessor :data
    attr_accessor :errors
    attr_accessor :authentication

    def initialize 
      # @attribute = attribute
    end

    def get_projects
      response = HTTParty.get("https://api.productive.io/api/v2/projects", :headers => set_headers)
      @data = response.parsed_response["data"]
      # puts @result

      @data.each do |hash|
        puts hash["id"] + " " + hash["type"]
      end
    end

    def get_project_by_id id
      url = "https://api.productive.io/api/v2/projects/#{id}"
      # puts url

      response = HTTParty.get(url, :headers => set_headers)
      @errors = response.parsed_response["errors"]
      pp @errors

    end


  end
end