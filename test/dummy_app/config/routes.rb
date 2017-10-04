# frozen_string_literal: true
Rails.application.routes.draw do
  resources :posts, only: :show do
    collection do
      get :hello
    end
  end

  resources :benchmarks, only: :index

  if Rails::VERSION::MAJOR >= 5
    namespace :api do
      resources :posts, only: :show
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
