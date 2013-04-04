DeLaRueApp::Application.routes.draw do

  root to: 'pages#home'
  
  get 'main' => 'pages#main', as: :main
  
  get 'login' => 'sessions#create', as: :login
  
  get 'signup' => 'users#new', as: :signup
  
  resources :users

end
