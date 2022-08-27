Rails.application.routes.draw do
  root 'videos#index'
  resources :videos, only: :index

  post 'authenticate', to: 'authentications#create'
  delete 'logout', to: 'authentications#destroy'
end
