Rails.application.routes.draw do
  resources :books, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  resources :users
end
