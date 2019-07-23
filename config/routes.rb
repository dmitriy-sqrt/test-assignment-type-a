Rails.application.routes.draw do
  resources :invoice_reports, only: [:index, :show, :new, :create]

  root 'invoice_reports#index'
end
