Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'projects/index'
      get 'projects/show'
      get 'projects/get_projects'
      get 'projects/get_project_by_id'

      get 'api_test/test_get_project_by_id'
    end
  end
end
