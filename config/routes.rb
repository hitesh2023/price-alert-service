Rails.application.routes.draw do
	resources :alerts, only: [:create, :destroy]
  post 'authenticate', to: 'authentication#authenticate'
end
