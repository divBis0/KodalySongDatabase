Rails.application.routes.draw do
  resources :sources
  resources :fields
  resources :field_categories
  get 'site/index'

  devise_for :users, :skip => [:registrations]
  as :user do
    get     'users/cancel(.:format)'  => 'devise_invitable/registrations#cancel', :as => "cancel_user_registration"
    get     'users/edit(.:format)'    => 'devise_invitable/registrations#edit',   :as => "edit_user_registration"
    patch   'users(.:format)'         => 'devise_invitable/registrations#update', :as => "user_registration"
    put     'users(.:format)'         => 'devise_invitable/registrations#update'
    delete  'users(.:format)'         => 'devise_invitable/registrations#destroy'
#     new_user_registration GET    /users/sign_up(.:format)             devise_invitable/registrations#new
#    post    'users(.:format)'         => 'devise_invitable/registrations#create'
  end
  constraints(id: /[0-9]+/) do
    resources :songs
  end
  constraints(alpha: /[A-Z]+/) do
    get 'songs/:alpha', to: 'songs#index', as: 'songs_by_letter'
  end
  get 'advanced_search' => 'advanced_search#index'
  get 'advanced_search/list' => 'advanced_search#list'
  get 'advanced_search/show' => 'advanced_search#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'site#index'
end
