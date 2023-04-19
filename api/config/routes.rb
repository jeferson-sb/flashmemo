Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  scope '/api' do
    # resources :answers, only: %[index show]
    # resources :questions, only: %[index show]
    get "answers/:id", to: "answers#show"
    get "questions/:id", to: "questions#show"
    get "questions", to: "questions#index"
  end
end
