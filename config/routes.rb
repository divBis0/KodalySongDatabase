Rails.application.routes.draw do
  resources :sources
  resources :fields
  resources :field_categories
  get 'site/index'

  devise_for :users
  resources :songs
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'site#index'
end
