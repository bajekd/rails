Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'blog_posts#index'

  resources :blog_posts do
    resource :cover_image, only: %w[destroy], module: :blog_posts
  end
end
