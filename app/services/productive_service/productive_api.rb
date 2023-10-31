# app/services/productive_api.rb
module ProductiveService
  class ProductiveApi
    include HTTParty
    base_uri 'https://api.productive.io/api/v2'

    def initialize()
      @headers = {
        "X-Auth-Token" => "c664831b-4419-4bb0-9dc0-09816f04cea2",
        "X-Organization-Id" => "30958",
        "Content-Type" => "application/vnd.api+json"
      }
    end

    def get_projects
      response = self.class.get('/projects', headers: @headers)
      handle_response(response)
    end

    private

    def handle_response(response)
      if response.success?
        parsed_data = JSON.parse(response.body)
        if parsed_data.is_a?(Array)
          parsed_data.map { |project_data| Project.new(project_data) }
        else
          Project.new(parsed_data)
        end
      else
        raise "API request failed with status #{response.code}: #{response.body}"
      end
    end

  end

end