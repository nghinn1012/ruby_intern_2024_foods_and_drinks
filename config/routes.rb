Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "static_pages/home"
    root "static_pages#home"

    get "signup", to: "users#new"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    delete "/admin/foods/:id", to: "admin/foods#destroy", as: "admin_food"
    get "cart", to:"cart#show"
    post "add_to_cart/:id", to: "cart#create", as: "add_to_cart"
    delete "cart_destroy/:id", to: "cart#destroy", as: "cart_destroy"
    delete "cart_destroy_all", to: "cart#destroy_all"
    get "order_history", to: "orders#index"
    get "checkout", to:"orders#new"
    post "checkout", to:"orders#create"
    resources :orders
    resources :cart do
      member do
        post :update_quantity, action: :update_quantity
      end
    end
    resources :users, only: %i(create)
    resources :categories
    resources :foods, only: %i(create index show update)
    namespace :admin do
      resources :foods
    end
  end
end
