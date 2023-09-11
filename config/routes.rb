Rails.application.routes.draw do
  root "static_pages#home"
  get "static_pages/home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :products
end
