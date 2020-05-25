Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.map(&:to_s).join("|")}/ do
    root to: "home#top"
    get "useful_pages", to: "home#useful_pages"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    resources :posts
    resources :users, except: [:index]
    resources :password_resets, only: [:new, :create, :edit, :update]
  end
end
