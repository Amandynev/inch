Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :people, only: [:index] do
    collection do
      post :import
    end
  end

  resources :buildings, only: [:index] do
    collection do
      post :import
    end
  end
end
