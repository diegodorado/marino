Marino::Application.routes.draw do
  
  resources :stores


  resources :companies, :only => [:index] do
    get 'select', :on => :member
  end
  
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :crops


  resources :crop_controls
  resources :backups

  devise_for :users, :controllers => { :sessions => "sessions" }

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"  


  root :to => "home#index"

end
