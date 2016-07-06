Rails.application.routes.draw do
  get 'benchmarks/index'

  resources :posts, only: :show do
    collection do
      get :hello
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
