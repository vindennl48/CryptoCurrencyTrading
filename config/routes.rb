Rails.application.routes.draw do
  resources :transactions
  get 'dashboard/index'

  resources :apis

  root 'dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
