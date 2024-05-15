Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
  # Ex:- scope :active, -> {where(:active => true)}
  get "static_pages/home"
  root "static_pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "signup", to: "users#new"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  resources :users, only: [:create]
  end
end
