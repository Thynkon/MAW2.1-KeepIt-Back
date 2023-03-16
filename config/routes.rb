Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :books, only: [:index, :show] do
    collection do
      get 'search'
      put '/:id/upvote', to: 'books#upvote'
      put '/:id/downvote', to: 'books#downvote'
      delete '/:id/unvote', to: 'books#unvote'
      put '/:id/track', to: 'books#track'
    end
  end

  resources :movies, only: [:show] do
    collection do
      get 'search'
      get 'popular'
    end
  end

  resources :shows, only: [:show] do
    collection do
      get 'search'
      get 'popular'
    end
    resources :seasons, only: [:show] do
      resources :episodes, only: [:show]
    end
  end

  resources :users
end
