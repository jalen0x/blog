Rails.application.routes.draw do
  draw :madmin
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "posts#index"

  get "posts/:slug", to: "posts#show", as: :post
  get "about", to: "pages#about"

  get "posts/:slug.md", to: "posts#show", format: :md, as: :post_md
  get "llm.txt", to: "pages#llm", format: :text
  get "sitemap.xml", to: "pages#sitemap", format: :xml, as: :sitemap
  get "feed.xml", to: "posts#feed", format: :rss, as: :feed
end
