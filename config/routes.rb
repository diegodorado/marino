Marino::Application.routes.draw do
  
  scope '/api' do
    resources :stores, except: [:new, :edit]
  end

  match "/images/uploads/*path" => "gridfs#serve"

  resources :stores

  resources :companies, :only => [:index] do
    get 'select', :on => :member
    post 'comment', :on => :member
  end

  resources :crop_controls do
    post 'excel', :on => :collection
    get 'list', :on => :collection
    get 'summary', :on => :collection
  end
  resources :backups

  devise_for :users, :controllers => { :sessions => "sessions", :registrations => "registrations", :passwords=> "passwords" , :omniauth_callbacks => "omniauth_callbacks" }

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"

  namespace :admin do
    resources :roles
    resources :users
    resources :companies
    resources :crops do
      get 'get_price', :on => :collection
    end
    resources :invoices do
      get 'cae', :on => :member
      get 'pdf', :on => :member
    end
  end

  root :to => "home#index"
  resources :recipes, only: [:index]

  get "/select-company/:id"  => "home#select_company", :as => 'select_company'


end
