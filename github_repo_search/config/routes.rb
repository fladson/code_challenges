Rails.application.routes.draw do
  root 'public_repositories#index'
  post 'search', to: 'public_repositories#search'
end
