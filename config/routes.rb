Rails.application.routes.draw do
  get 'about', to: 'about#index'
  get 'privacy', to: 'privacy#index'
  get 'terms', to: 'terms#index'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :messages, param: :url_token

  root 'messages#index'
end
