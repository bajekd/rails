Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :links
  resources :views, path: :v, only: %i[show]
  root 'links#index'
end
