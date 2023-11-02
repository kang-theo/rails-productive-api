Rails.application.routes.draw do
  namespace :api do
    namespace :v2 do
      get 'projects/all'
      get 'projects/find'
    end
  end
end
