Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "static_pages/home"
    root "static_pages#home"

    get "signup", to: "users#new"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    resources :users, only: %i(create)
    resources :categories
    resources :foods, only: %i(create index show update)
    namespace :admin do
      resources :foods
    end
  end
end
