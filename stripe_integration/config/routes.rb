Rails.application.routes.draw do
  devise_for :users

  resources :products
  post "products/add_to_cart/:id", to: 'products#add_to_cart', as: "add_to_cart"
  delete "products/remove_from_cart/:id", to: 'products#remove_from_cart', as: "remove_from_cart"

  resources :posts

  post  'checkout/create', to: 'checkout#create'
  get 'success', to: 'checkout#success'
  get 'cancel', to: 'checkout#cancel'

  resources :webhooks, only: [:create]

  root 'products#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
