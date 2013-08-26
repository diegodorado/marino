Marino::Application.routes.draw do

  resources :crops


  resources :posts


  match "/images/uploads/*path" => "gridfs#serve"

  resources :stores


  resources :companies, :only => [:index] do
    get 'select', :on => :member
    post 'comment', :on => :member
  end

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :crops do
    get 'get_price', :on => :collection
  end


  resources :crop_controls
  resources :backups

  devise_for :users, :controllers => { :sessions => "sessions", :registrations => "registrations", :passwords=> "passwords" , :omniauth_callbacks => "omniauth_callbacks" }

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"  


  root :to => "home#index"

end
