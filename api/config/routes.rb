Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  scope '/api' do
    resources :answers, only: [:show]
    resources :questions, only: %i[index show create] do
      get 'random', on: :collection
    end
    resources :exams, only: %i[show] do
      post '/evaluate', to: 'exams#evaluate'
    end
  end
end
