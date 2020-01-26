# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root to: "posts#index"
  resources :posts

  get "users/index"
  get "users/show"
  get "users/new"
  get "users/edit"
end
