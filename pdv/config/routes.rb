Rails.application.routes.draw do
  resources :products
  resources :users
  post 'authenticate', to: 'auth#authenticate'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
