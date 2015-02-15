Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'details#index'

  get 'details', to: 'details#index', as: 'details'
  get 'details/new', to: 'details#new', as: 'details_new'
  post 'details', to: 'details#create'
end
