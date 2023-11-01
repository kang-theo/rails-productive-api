# app/services/productive_api.rb
module ProductiveService
  class ProductiveApi
    include HTTParty
    base_uri 'https://api.productive.io/api/v2'

    def initialize(api_key, org_id)
      @headers = {
        "X-Auth-Token" => api_key,
        "X-Organization-Id" => org_id,
        "Content-Type" => "application/vnd.api+json"
      }
    end

    def all()
      # response = self.class.get('/projects', headers: @headers)
      process_request()
    end

    def find(id)
      process_request(id)
    end

    private

    def handle_response(response)
      if response.success?
        parsed_data = JSON.parse(response.body)["data"]
        # debugger
        if parsed_data.is_a?(Array)
          parsed_data.map { |project_data| Project.new(project_data) }
        else
          Project.new(parsed_data)
        end
      else
        raise "API request failed with status #{response.code}: #{response.body}"
      end
    end

    def process_request(endpoint = "")
      response = self.class.get("/#{pluralized_resource_name()}/#{endpoint}", headers: @headers)
      handle_response(response)
    end

    def pluralized_resource_name
      self.class.name.split(/(?=[:A-Z])/).fifth.downcase.pluralize
    end

  end

end