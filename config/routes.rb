Rails.application.routes.draw do
  get 'books', to: 'books#index'
  get 'books/search', to: 'books#search'

  resources :users
  post 'auth/login', to: 'authentication#authenticate'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
