Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks',
               confirmations: 'users/confirmations',
               registrations: 'users/registrations'
             }
  resources :users, only: %i[index show]

  resources :comments, only: [] do
    resources :comments, only: %i[new create destroy]
  end

  resources :posts do
    resources :comments, only: %i[new create destroy]
    member do
      patch 'upvote', to: 'posts#upvote'
      patch 'downvote', to: 'posts#downvote'
    end
  end

  resources :webhooks, only: [:create]
  post 'checkout/create', to: 'checkout#create', as: 'checkout_create'
  post 'billing_portal/create', to: 'billing_portal#create', as: 'billing_portal_create'

  root 'static_public#landing_page'
  get 'about', to: 'static_public#about'
  get 'privacy', to: 'static_public#privacy'
  get 'terms', to: 'static_public#terms'
  get 'pricing', to: 'static_public#pricing'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
