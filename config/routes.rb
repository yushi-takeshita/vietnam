# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root to: "posts#index"
  resources :posts

  get "/user_create", to: "users#new"
  post "/user_create", to: "users#create"
  get "users/show"
  get "users/edit"
end
