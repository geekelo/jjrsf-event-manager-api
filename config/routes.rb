Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  namespace :api do
    namespace :v1 do
      post "signup" => "registration#create"
      post "login" => "authentication#create"
      post "frontdesk_auth" => "event_front_desks#authenticate_frontdesk"
      patch "mark_attendee" => "event_attendees#mark_attendance"
      post "verify_guest" => "event_quick_registrations#verify_guest"
      get "events" => "foundation_events#visible_events"
      get "access_front_desk" => "event_front_desks#authenticate_front_desk"
      post "direct_email" => "send_emails#direct_email"
      post "bulk_email" => "send_emails#bulk_email"
      post "notify_attendees" => "event_attendees#notify_attendees"

      resources :foundation_events, only: [:index, :show, :create, :update, :destroy]
      resources :event_streaming_platforms, only: [:index, :create, :update, :destroy]
      resources :event_front_desks, only: [:index, :create, :update, :destroy]
      resources :event_attendees, only: [:index, :create, :update]
      resources :event_feedbacks, only: [:index, :create, :update, :destroy]
      resources :event_quick_registrations, only: [:index, :create, :update, :destroy]
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
