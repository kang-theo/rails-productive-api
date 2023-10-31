require 'json'
module Base
  HOST = 'https://api.productive.io/api/v2'

  module ReqParamBuilder
    # def set_options()
    #   ActiveSupport::JSON.encode({ :headers => set_option_headers, :body => create_body("post_proj2", "602830", "521440", "31589")})
    # end
    def set_payload(name)
      ActiveSupport::JSON.encode(create_body(name, "602830", "521440", "31589"))
    end

    def set_auth_headers(is_bulk=false)
    {
      #TODO: auth info should go to config and encrypted
      "X-Auth-Token" => "c664831b-4419-4bb0-9dc0-09816f04cea2",
      "X-Organization-Id" => "30958",
      "Content-Type" => (is_bulk ?  "application/vnd.api+json; ext=bulk" : "application/vnd.api+json")
    }
    end

    def set_option_headers
    #   auth_headers = set_auth_headers
      optional_headers = 
      { 
          "Accept" => "text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5"
      }
    #   auth_headers.merge(optional_headers)
    end
  
    def create_body(name, company_id = "", project_manager_id = "", workflow_id = "") 
    # payload = {
    #   "data": {
    #       "type": "projects",
    #       "attributes": {
    #       "name": "#{name}",
    #       "project_type_id": 2
    #       },
    #       "relationships": {
    #       "company": {
    #           "data": {
    #           "type": "companies",
    #           "id": "#{company_id}"
    #           }
    #       },
    #       "project_manager": {
    #           "data": {
    #           "type": "people",
    #           "id": "#{project_manager_id}"
    #           }
    #       },
    #       "workflow": {
    #           "data": {
    #           "type": "workflows",
    #           "id": "#{workflow_id}"
    #           }
    #         }
    #       }
    #     }
    #   }
    payload = 
      {
        "data": {
          "type": "projects",
          "attributes": {
            "name": "#{name}"
          }
        }
      }
    end
  end
end