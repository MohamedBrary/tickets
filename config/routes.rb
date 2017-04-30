Rails.application.routes.draw do
  resources :tickets do
    collection do
      # get :export_as_pds
    end
    member do
      get :assign
      get :resolve
    end
  end

  devise_for :users
  resources :users
  
  resources :admins, controller: 'users', type: 'Admin' 
	resources :agents, controller: 'users', type: 'Agent' 
	resources :customers, controller: 'users', type: 'Customer'

  get 'home/index'
  root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
