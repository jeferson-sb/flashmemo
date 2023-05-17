Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  scope '/api' do
    resources :answers, only: [:show]
    resources :questions, only: %i[show index] do
    get "/random", to: 'questions#random'
  end
end
