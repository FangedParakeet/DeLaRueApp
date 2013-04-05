DeLaRueApp::Application.routes.draw do

  root to: 'pages#home'
  
  get 'main' => 'pages#main', as: :main
  
  post 'login' => 'sessions#create', as: :login
  
  get 'signup' => 'users#new', as: :signup
  
  get 'logout' => 'sessions#destroy', as: :logout
  
  resources :users

end
