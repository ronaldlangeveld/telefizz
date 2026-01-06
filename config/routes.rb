Rails.application.routes.draw do
  namespace :telefizz do
    get "/", to: "home#index", as: :dashboard

    get "/board", to: "board#index", as: :board
    get "/board/new", to: "board#new", as: :new_board
    post "/board", to: "board#create", as: :create_board
    get "/board/:id", to: "board#show", as: :show_board
    get "/board/:id/setup", to: "board#setup", as: :setup_board
    patch "/board/:id/setup", to: "board#save_secret", as: :save_secret_board
    post "/board/:id/integrations/:integration_id", to: "board#add_integration", as: :add_board_integration
    delete "/board/:id/integrations/:integration_id", to: "board#remove_integration", as: :remove_board_integration

    # Integrations
    get "/integrations", to: "integrations#index", as: :integrations
    get "/integrations/telegram/new", to: "integrations#new_telegram", as: :new_telegram_integration
    post "/integrations/telegram", to: "integrations#create_telegram", as: :create_telegram_integration
    get "/integrations/telegram/:id/edit", to: "integrations#edit_telegram", as: :edit_telegram_integration
    patch "/integrations/telegram/:id", to: "integrations#update_telegram", as: :update_telegram_integration
    delete "/integrations/telegram/:id", to: "integrations#destroy_telegram", as: :destroy_telegram_integration

    # Slack Integration
    get "/integrations/slack/new", to: "integrations#new_slack", as: :new_slack_integration
    post "/integrations/slack", to: "integrations#create_slack", as: :create_slack_integration
    get "/integrations/slack/:id/edit", to: "integrations#edit_slack", as: :edit_slack_integration
    patch "/integrations/slack/:id", to: "integrations#update_slack", as: :update_slack_integration
    delete "/integrations/slack/:id", to: "integrations#destroy_slack", as: :destroy_slack_integration
  end
  namespace :public do
    get "home/index"
  end
  resource :session
  # resources :passwords, param: :token

  # Magic link authentication
  get "magic_link/:token", to: "magic_links#show", as: :magic_link

  # Webhooks
  post "webhooks/:uuid", to: "webhooks#create", as: :webhook

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "public/home#index"
end
