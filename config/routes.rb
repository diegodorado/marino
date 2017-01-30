Marino::Application.routes.draw do

  scope '/api', :module => :api do
    resources :crops, except: [:new, :edit]
    resources :stores, except: [:new, :edit]
    resources :crop_controls, except: [:new, :edit] do
      get 'list', :on => :collection
      get 'summary', :on => :collection
    end
  end

  devise_for :users, :controllers => { :sessions => "sessions", :registrations => "registrations", :passwords=> "passwords"  }

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"

  namespace :admin do
    resources :roles
    resources :users
    resources :companies
    resources :crops do
      get 'prices', :on => :collection
    end
    resources :invoices do
      get 'cae', :on => :member
      get 'pdf', :on => :member
    end
  end

  root :to => "home#index"

  get "/select-company/:id"  => "home#select_company", :as => 'select_company'
  get "/companies/stores" => "companies#stores"
  get "/companies/marketing_costs" => "companies#marketing_costs"
  get "/crop_controls/index" => "crop_controls#index"
  get "/crop_controls/summary" => "crop_controls#summary"

  resources :crop_controls do
    post 'excel', :on => :collection
  end


end
