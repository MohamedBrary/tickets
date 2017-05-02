Rails.application.routes.draw do
  resources :tickets do
    collection do
      # get :export_as_pds
    end
    member do
      post :assign
      get :resolve
      patch :resolved
    end
  end

  # this order, allows "POST /user" to be processed by UsersController
  post '/users/', to: 'users#create'
  get '/users/:id/edit', to: 'users#edit'
  put '/users/:id', to: 'users#update'
  patch '/users/:id', to: 'users#update'
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  
  resources :admins, controller: 'users', type: 'Admin' 
	resources :agents, controller: 'users', type: 'Agent' 
	resources :customers, controller: 'users', type: 'Customer'

  get 'home/index'
  root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
