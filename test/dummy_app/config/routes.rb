# frozen_string_literal: true
Rails.application.routes.draw do
  resources :posts, only: :show do
    collection do
      get :hello
    end
  end

  resources :benchmarks, only: :index
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
