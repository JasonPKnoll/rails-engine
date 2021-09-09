Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'welcome/homepage'
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#find'
      get 'items/find_all', to: 'items/search#find_all'

      resources :customers, only: [:index, :show]
      resources :merchants, only: [:index, :show] do
        get '/items', to: 'merchant_items#index'
        # resources :items, as: :merchant_items, only: :index
      end

      resources :items, except: [:new, :edit] do
        get "/merchant", to: 'items#find_merchant'
      end
    end
  end
end
