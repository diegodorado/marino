Marino::Application.routes.draw do
  

  

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :crops


  resources :messages
  resources :backups

  devise_for :users

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"  


  root :to => "home#index"

end
