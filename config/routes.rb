Rails.application.routes.draw do
  root to: 'brands#index'
  resources :brew_logs
  resources :kettles
  resources :brands do
    patch :brew
  end
end
