# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'up', to: 'rails/health#show', as: :rails_health_check

  scope '/api' do
    resource :sessions
    resources :passwords, param: :token
    resources :answers, only: %i[show create]
    resources :revisions, only: %i[show] do
      post '/evaluate', to: 'revisions#evaluate'
    end
    resources :questions do
      get 'random', on: :collection
      post 'bulk', on: :collection
    end
    resources :exams do
      post '/evaluate', to: 'exams#evaluate'
      get 'duos', to: 'exams#duos'
      post 'duos/evaluate', to: 'exams#evaluate_duos'
    end
    resources :users, only: %i[create] do
      get '/progress', to: 'users#progress'
    end
    resources :categories, only: %i[index create]
    resources :gardens, only: %i[index show create] do
      post '/plant', to: 'gardens#plant'
      post '/nurture', to: 'gardens#nurture'
      get '/journal', to: 'gardens#journal'
      post '/journal/surprise_question', to: 'gardens#evaluate_surprise_question'
    end
    resources :trees, only: %i[index show]
    resources :mindmaps do
      post '/nodes', to: 'mindmaps#update_node'
    end
  end
end
