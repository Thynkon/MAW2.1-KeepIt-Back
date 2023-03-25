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
      put 'track'
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
      resources :episodes, only: [:show] do
        member do
          put 'track'
        end
      end
    end
  end

  resources :users do
    resources :achievements, only: [:index]
    member do
      get 'achievements/count', to: 'achievements#count'
    end
  end

  # Achievements of current user
  resources :achievements, only: [:index, :show]
end
