Rails.application.routes.draw do
  root 'events#index'

  devise_for :users, controllers: {
      registrations: 'registrations'
  }

  resources :users do
    resources :events
  end

  resources :events
end
