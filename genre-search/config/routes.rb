Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'movies', to: 'movies#show'
    end
  end
end
