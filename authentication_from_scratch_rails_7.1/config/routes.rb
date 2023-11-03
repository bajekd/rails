Rails.application.routes.draw do
  resource :registration
  resource :session
  resource :password_reset
  resource :password

  scope controller: :main do
    get :projects
    get :tasks
    get :calendar
    get :announcements
  end

  root 'main#index'
end
