#require 'sidekiq/web'

Babe::Application.routes.draw do
  
  #mount Sidekiq::Web => '/sidekiq'

  get "account/avatar" => "profile#avatar"
  patch "account/avatar" => "profile#upload"
  get "account/password" => "profile#edit"
  put "account/password" => "profile#update"
  get "account/addition" => "profile#addition"
  post "account/addition" => "profile#save"

  devise_for :users, :path => "account", :controllers => {
    :registrations => :account,
    :sessions => :sessions,
    :omniauth_callbacks => :oauths
  }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'home#index'

  get '/search/:word' => 'home#search', as: 'search'
  get '/about/:slug' => 'help#about', as: 'about'
  get '/help/:slug(/:page)' => 'help#view', as: 'help'

  resources :photos
  resources :comments
  #resources :help

  # Why made /first/second?third=value ?
  get 'explore/:first(/:second(/:third))' => "categories#index", as: 'explore'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  resources :styles do
    member do
      post 'like'
    end
  end

  resources :items do
    member do
      post 'like'
      delete 'like' => 'items#unlike'
    end

    collection do
      get 'fetch'
      get 'fans'
      get 'more'
    end
  end

  resources :topics, :path => 'forum' do
    collection do
      get 'node/:id' => 'topics#node', as: 'node'
      get 'topic/:id' => 'topics#show', as: 'topic'
    end
  end

  namespace :cpanel do
    
    root :to => "home#index"
    
    resources :categories, path: 'category'

    resources :sections
    resources :nodes
    resources :topics
    resources :styles do
      collection do
        post 'cancel'
        post 'remove'
        post 'recommend'
      end
    end
    resources :positions
    resources :ads
    resources :catalogs
    resources :pages
    resources :tags

    resources :users do
      collection do
        get 'admin'
      end
    end
    
    resources :tasks do
      collection do
        post 'fetch'
        get 'promotion'
        get 'todaypromo'
        post 'recommend'
        post 'cancel'
      end
    end

    resources :items do
      collection do
        post 'remove'
        post 'cancel'
        post 'moveto'
        post 'free'
        post 'band'
        post 'bind'
        get 'tags'
        post 'pin'
      end
    end
  end


  get "users", :to => "users#index", :as => :users
  
  resources :users, :path => "" do
    member do
      get :items
      get :likes
      get :followers
      get :following
      get :topics
    end

    post "follow" => :follow
    delete "follow" => :unfollow
  end
  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
