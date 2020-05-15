Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.map(&:to_s).join("|")}/ do
    root to: "home#top"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    resources :posts
    resources :users
    resources :password_resets, only: [:new, :create, :edit, :update]
  end
end
