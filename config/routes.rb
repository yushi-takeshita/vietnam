Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.map(&:to_s).join("|")}/ do
    controller :home do
      root to: "home#top"
      get "useful_pages", to: "home#useful_pages"
    end

    controller :sessions do
      get "login", to: "sessions#new"
      post "login", to: "sessions#create"
      delete "logout", to: "sessions#destroy"
    end

    controller :users do
      resources :users, except: [:index]
    end

    controller :password_resets do
      resources :password_resets, only: [:new, :create, :edit, :update]
    end

    controller :posts do
      get "categories/(:category_id)/index", to: "posts#index", as: "category"
      resources :posts, except: [:index] do
        resources :comments, only: [:create, :destroy], controller: "comments"
      end
    end

    controller :categories do
      get "categories/new", to: "categories#new", defaults: { format: "json" }
      get "categories/pulldown", to: "categories#pulldown", defaults: { format: "json" }
    end
  end
end
