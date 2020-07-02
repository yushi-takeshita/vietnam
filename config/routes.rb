Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.map(&:to_s).join("|")}/ do
    root to: "home#top"
    get "useful_pages", to: "home#useful_pages"
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    resources :users, except: [:index]
    resources :password_resets, only: [:new, :create, :edit, :update]

    controller :posts do
      resources :posts, except: [:index]
      get "categories/(:category_id)/index", to: "posts#index", as: "category"
    end
    controller :categories do
      get "categories/new", to: "categories#new", defaults: { format: "json" }
    end
  end
end
