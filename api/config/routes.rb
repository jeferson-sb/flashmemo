# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  scope '/api' do
    resources :answers, only: [:show]
    resources :questions do
      get 'random', on: :collection
    end
    resources :exams, only: %i[show create] do
      post '/evaluate', to: 'exams#evaluate'
    end
    resources :users, only: %i[create]
  end
end
