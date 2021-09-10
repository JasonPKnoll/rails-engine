# frozen_string_literal: true

Rails.application.routes.draw do
  get 'welcome/homepage'
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#find'
      get 'revenue/merchants/:id', to: 'merchants/revenue#merchant_total_revenue'
      get 'revenue/merchants', to: 'merchants/revenue#most_revenue_merchants'
      get 'items/find_all', to: 'items/search#find_all'
      get 'revenue/items', to: 'items/revenue#most_revenue_items'
      get 'revenue/unshipped', to: 'merchants/revenue#unshipped'

      resources :customers, only: %i[index show]
      resources :merchants, only: %i[index show] do
        get '/items', to: 'merchant_items#index'
      end

      resources :items, except: %i[new edit] do
        get '/merchant', to: 'items#find_merchant'
      end
    end
  end
end
