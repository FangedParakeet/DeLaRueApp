DeLaRueApp::Application.routes.draw do

  root to: 'pages#home'
  
  get 'search' => 'pages#search'

end
