# module ProductiveApi

  class Base
   @@settings = nil

   class << self
      # load settings from config
      def load_settings
        @@settings
      end

      def model_base_uri
        "https://api.productive.io/api/v2"
      end

      def set_uri (type, id, base_uri)
        case type
          when "all", "create"
            base_uri
          when "copy"
            base_uri + "/copy"
          when "archive"
            base_uri + "/#{id}/archive"
          when "restore"
            base_uri + "/#{id}/restore"
          else
            base_uri + "/#{id}"
          end
      end

      def set_options (body)
        options = body ? { :headers => set_body_headers, :body => set_body(body).to_json } : { :headers => set_body_headers }
        
      end

      def set_auth_headers is_bulk=false
        {
          "X-Auth-Token" => "0b74561b-0d18-4996-bb69-7ffa59a40681",
          "X-Organization-Id" => "30958",
          "Content-Type" => (is_bulk ?  "application/vnd.api+json; ext=bulk" : "application/vnd.api+json")
        }
      end

      def set_body_headers
        auth_headers = set_auth_headers
        body_headers = 
        { 
            "Accept" => "text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5"
        }
        auth_headers.merge(body_headers)
      end

      def set_body (body)
        body
      end

      def create_body 
          {
          "data": {
              "type": "projects",
              "attributes": {
              "name": "post_proj1",
              "project_type_id": 2
              },
              "relationships": {
              "company": {
                  "data": {
                  "type": "companies",
                  "id": "602830"
                  }
              },
              "project_manager": {
                  "data": {
                  "type": "people",
                  "id": "521440"
                  }
              },
              "workflow": {
                  "data": {
                  "type": "workflows",
                  "id": "31589"
                  }
              }
              }
            }
          }
      end

      def update_body
          {
          "data": {
              "type": "projects",
              "attributes": {
              "name": "update_proj1"
              }
            }
          }
      end

      # def error_parse (status_code)
      #   case status_code
      #   when "111"
      #     @error = "Invalid type."
      #   when "135"
      #     @error = "Unknown device type."
      #   when "202"
      #     @error = "Username already taken."
      #   when "203"
      #     @error = "Email already taken."
      #   when "400"
      #     @error = "Bad Request: The request cannot be fulfilled due to bad syntax."
      #   when "401"
      #     @error = "Unauthorized: Check your App ID & Master Key."
      #   when "403"
      #     @error = "Forbidden: You do not have permission to access or modify this."
      #   when "408"
      #     @error = "Request Timeout: The request was not completed within the time the server was prepared to wait."
      #   when "415"
      #     @error = "Unsupported Media Type"
      #   when "500"
      #     @error = "Internal Server Error"
      #   when "502"
      #     @error = "Bad Gateway"
      #   when "503"
      #     @error = "Service Unavailable"
      #   when "508"
      #     @error = "Loop Detected"
      #   else
      #     @error = "Unknown Error"
      #     raise "Parse error #{code}: #{@error} #{@msg}"
      #   end
      # end
    end
  end
# end