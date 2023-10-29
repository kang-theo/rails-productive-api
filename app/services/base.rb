module Base
  HOST = 'https://api.productive.io/api/v2'

  module ReqParamBuilder
      module HeadersBuilder
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
      end
  
      module BodyBuilder
          def create_body(name, company_id, project_manager_id, workflow_id) 
            {
            "data": {
                "type": "projects",
                "attributes": {
                "name": "#{name}",
                "project_type_id": 2
                },
                "relationships": {
                "company": {
                    "data": {
                    "type": "companies",
                    "id": "#{company_id}"
                    }
                },
                "project_manager": {
                    "data": {
                    "type": "people",
                    "id": "#{project_manager_id}"
                    }
                },
                "workflow": {
                    "data": {
                    "type": "workflows",
                    "id": "#{workflow_id}"
                    }
                  }
                }
              }
            }
        end
      end
  end
end