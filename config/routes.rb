Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"

  resources :customers
  resources :bikes
  resources :repairs
  resources :jobs, path: "services"
  resources :staff_members, path: "staff"

  get "visiting", to: "pages#visiting", as: :visiting
  get "about", to: "pages#about", as: :about
end
