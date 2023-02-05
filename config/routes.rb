Rails.application.routes.draw do
  resources :books, only: [:index, :show] do
    collection do
      get 'search'
      put '/:id/upvote', to: 'books#upvote'
      put '/:id/downvote', to: 'books#downvote'
      delete '/:id/unvote', to: 'books#unvote'
    end
  end

  resources :users
end
