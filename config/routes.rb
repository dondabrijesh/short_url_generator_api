Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :short_url, only: [ :create ]
      patch "/short_url/:short_code", to: "short_url#deactivate", as: :deactivate_short_url
      get "/short_url/analytics", to: "short_url#analytics", as: :analytics
    end
  end
  get "/:code", to: "redirects#show", as: :redirect
end
