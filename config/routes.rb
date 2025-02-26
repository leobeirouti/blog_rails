Rails.application.routes.draw do
  devise_for :users
  root "articles#index"

  # Rotas para configuração do 2FA
  get  "/two_factor_auth/qr",       to: "two_factor_auth#show_qr"
  post "/two_factor_auth/enable",   to: "two_factor_auth#enable"
  post "/two_factor_auth/disable",  to: "two_factor_auth#disable"

  resources :articles do
    resources :comments
  end
end
