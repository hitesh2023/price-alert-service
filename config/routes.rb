Rails.application.routes.draw do
	resources :alerts, only: [:create, :destroy]
end
