Rails.application.routes.draw do
  root 'videos#index'
  resources :videos, except: :show

  post 'authenticate', to: 'authentications#create'
  delete 'logout', to: 'authentications#destroy'
end
