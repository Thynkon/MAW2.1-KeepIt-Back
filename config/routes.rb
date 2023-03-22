Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :books, only: [:index, :show] do
    collection do
      get 'search'
    end

    member do 
      put 'upvote'
      put 'downvote'
      delete 'unvote'
      put 'track'
    end
  end

  resources :movies, only: [:show] do
    collection do
      get 'search'
      get 'popular'
    end

    member do 
      put 'upvote'
      put 'downvote'
      delete 'unvote'
    end
  end

  resources :shows, only: [:show] do
    collection do
      get 'search'
      get 'popular'
    end
    member do 
      put 'upvote'
      put 'downvote'
      delete 'unvote'
    end
    
    resources :seasons, only: [:show] do
      resources :episodes, only: [:show]
    end
  end

  resources :users do
    resources :achievements, only: [:index]
  end

  # Achievements of current user
  resources :achievements, only: [:index, :show]

  # Friendship invitations
  get '/friendship-invitations', to: 'users#friendship_invitations'

  # Profile
  get '/profile', to: 'users#profile'
end
