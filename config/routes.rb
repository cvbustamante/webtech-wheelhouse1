Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :registration, only: [:new, :create]
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"

  resources :customers
  resources :bikes
  resources :repairs do
    resources :intake_photos, only: [:destroy]
  end
  resources :jobs, path: "services"
  resources :staff_members, path: "staff"

  get "visiting", to: "pages#visiting", as: :visiting
  get "about", to: "pages#about", as: :about

  namespace :api do
    namespace :v1 do
      resources :services, only: [:index, :show, :create]
      resources :repairs, only: [:index, :show]
    end

    # cualquier otra cosa bajo /api/v1 responde el 404 en json, no la pagina html de rails
    match "v1/*path", to: "base#route_not_found", via: :all
  end
end
