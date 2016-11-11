Rails.application.routes.draw do
  devise_for :users
  namespace :users do
    resources :orders
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root 'users/orders#index'
  root 'landing#index'
end
