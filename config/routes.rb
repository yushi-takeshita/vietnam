Rails.application.routes.draw do
  root to: "posts#index"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  resources :posts
  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]
end
