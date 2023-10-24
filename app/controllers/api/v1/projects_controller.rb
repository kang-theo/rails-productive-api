require 'json'

class Api::V1::ProjectsController < ApplicationController
  def index
    result = '{
  "data": {
    "type": "projects",
    "attributes": {
      "name": "test name",
      "project_type_id": 2
    },
    "relationships": {
      "company": {
        "data": {
          "type": "companies",
          "id": "2081"
        }
      },
      "project_manager": {
        "data": {
          "type": "people",
          "id": "2748"
        }
      },
      "workflow": {
        "data": {
          "type": "workflows",
          "id": "633"
        }
      }
    }
  }
}'
    json_result = JSON.parse(result)
    puts json_result["data"]["type"]
    render json: result, status: 200
  end

  def show
  end
end
