Rails.application.routes.draw do
	resources :alerts, only: [:create, :destroy, :index]
  post 'login', to: 'authentication#login'
end
