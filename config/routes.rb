Rails.application.routes.draw do
  root      "posts#index"
  get       "login",    to: "sessions#new"
  post      "login",    to: "sessions#create"
  delete    "logout",   to: "sessions#destoy"
  resources :posts
  resources :users
end
