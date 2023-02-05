Rails.application.routes.draw do
  resources :books, only: [:index, :show] do
    collection do
      get 'search'
      put '/:id/upvote', to: 'books#upvote'
      put '/:id/downvote', to: 'books#downvote'
      delete '/:id/unvote', to: 'books#unvote'
    end
  end

  resources :movies, only: [:show] do
    collection do
      get 'search'
    end
  end

  resources :shows, only: [:show] do
    collection do
      get 'search'
    end
    resources :seasons, only: [:show] do
      resources :episodes, only: [:show]
    end
  end

  resources :users
end
