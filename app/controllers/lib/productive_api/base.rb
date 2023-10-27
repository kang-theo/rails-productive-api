module ProductiveApi

  @@settings = nil

  class Base
    # load settings from config
    def self.load_settings
      @@settings
    end

    def self.model_base_uri
      "https://api.productive.io/api/v2"
    end

    def self.set_uri (type, id)
      case type
        when "all", "create"
          uri
        when "copy"
          uri + "/copy"
        when "archive"
          uri + "/#{id}/archive"
        when "restore"
          uri + "/#{id}/restore"
        else
          uri + "/#{id}"
        end
    end

    def self.set_options (body)
      options = { :headers => set_body_headers, :body => set_body(body).to_json }
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

  end
end