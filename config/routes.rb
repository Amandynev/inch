Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "people#index"

  resources :people, only: [:index,:new, :update] do
    collection do
      post :import
    end
  end

  resources :buildings, only: [:index, :new, :update] do
    collection do
      post :import
    end
  end
end
