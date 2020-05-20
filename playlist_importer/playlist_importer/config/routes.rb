Rails.application.routes.draw do
  root                 to: 'home#index'
  get 'import',        to: 'file_importer#new'
  get 'songs',         to: 'songs#index'
  get 'users',         to: 'users#index'
  get 'users/:id',     to: 'users#show',     as: 'user'
  get 'playlists',     to: 'playlists#index'
  get 'playlists/:id', to: 'playlists#show', as: 'playlist'
  post 'import',       to: 'file_importer#import'
end
