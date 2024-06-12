Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users, controllers:
      {registrations: "users/registrations",
        confirmations: "users/confirmations",
        sessions: "users/sessions"}
    devise_scope :user do
      get "users/change_password" => "users/registrations#change"
      put "users/change_password" => "users/registrations#update_password"
    end
    get "static_pages/home"
    root "static_pages#home"
    get "signup", to: "users#new"
    post "signup", to: "users#create"
    get "/users/:id/edit", to: "users#edit", as: :edit_user
    patch "/users/:id", to: "users#update"
    put "/users/:id", to: "users#update"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    get "show_profile", to: "users#show"
    delete "/admin/foods/:id", to: "admin/foods#destroy", as: "admin_food"
    get "cart", to:"cart#show"
    post "add_to_cart/:id", to: "cart#create", as: "add_to_cart"
    delete "cart_destroy/:id", to: "cart#destroy", as: "cart_destroy"
    delete "cart_destroy_all", to: "cart#destroy_all"
    get "order_history", to: "orders#index"
    get "checkout", to:"orders#new"
    post "checkout", to:"orders#create"
    post "user_notifications/mark_as_read_all", to: "notifications#mark_as_read_all", as: "mark_as_read_all"
    resources :orders
    resources :cart do
      member do
        post :update_quantity, action: :update_quantity
      end
    end
    resources :users do
      resources :notifications do
        patch "mark_as_read", to:"notifications#mark_as_read"
      end
    end
    resources :categories
    resources :foods, only: %i(create index show update)
    namespace :admin do
      resources :foods
      resources :orders do
        member do
          patch :update_status
        end
      end
      resource :profile, only: %i(show edit update)
    end
  end
end
