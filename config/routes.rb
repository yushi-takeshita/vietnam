Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root to: "posts#index"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :posts
  resources :users
end
