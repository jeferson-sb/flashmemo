# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  scope '/api' do
    resources :answers, only: %i[show create]
    resources :revisions, only: %i[show] do
      post '/evaluate', to: 'revisions#evaluate'
    end
    resources :questions do
      get 'random', on: :collection
    end
    resources :exams, only: %i[index show create] do
      post '/evaluate', to: 'exams#evaluate'
    end
    resources :users, only: %i[create] do
      get '/progress', to: 'users#progress'
    end
    resources :categories, only: %i[create]
    post '/auth/login', to: 'authentication#login'
  end
end
