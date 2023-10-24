Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'projects/index'
      get 'projects/show'
    end
  end
end
