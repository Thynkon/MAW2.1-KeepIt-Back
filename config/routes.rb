Rails.application.routes.draw do
  get 'books', to: 'books#index'
  get 'books/search', to: 'books#search'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :movies, only: [:show] do
    collection do
      get 'search'
    end
  end

  resources :shows, only: [:show] do
    collection do
      get 'search'
    end
  end
end
