# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'people#index'

  resources :people, only: %i[index new update] do
    collection do
      post :import
    end
  end

  resources :buildings, only: %i[index new update] do
    collection do
      post :import
    end
  end
end
