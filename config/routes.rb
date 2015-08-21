Rails.application.routes.draw do
  scope '/v/:target', constraints: { target: /[^\/]+/ } do
    get '/maps', to: 'maps#index'

    get '/zones', to: 'zones#index'
    get '/zones/:slug', to: 'zones#show'

    get '/creatures', to: 'creatures#index'
    get '/creatures/:eid', to: 'creatures#show'
  end

  namespace :api, constraints: { target: /[^\/]+/ }, defaults: { format: :json } do
    get '/v/:target/maps.json', to: 'maps#index'

    get '/v/:target/zones.json', to: 'zones#index'
    get '/v/:target/zones/:slug/creatures.json', to: 'zones#creatures'

    get '/v/:target/creatures.json', to: 'creatures#index'
    get '/v/:target/creatures/:eid/level-stats.json', to: 'creatures#level_stats'
    get '/v/:target/creatures/:eid/instances.json', to: 'creatures#instances'
  end

  get '/target/:target', to: 'home#select_target', constraints: { target: /[^\/]+/ }

  get '/', to: 'home#index'
end
