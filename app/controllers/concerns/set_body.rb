module SetBody
  extend ActiveSupport::Concern

  # can integrate the set_xx methods to Projects module
  #TODO: need to fill info dynamically
  def set_body
{
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
}
  end
end