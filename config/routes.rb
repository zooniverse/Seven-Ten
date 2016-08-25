Rails.application.routes.draw do
  defaults format: 'json' do
    resources :metrics
    resources :projects
    resources :split_user_variants
    resources :splits
    resources :variants

    root 'application#root'
  end
end
