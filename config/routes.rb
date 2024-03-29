RevootApp::Application.routes.draw do

  resources :users do
    member do
      get :followed_shows
    end
  end
  resources :tv_shows do
    member do
      get :tv_show_followers
    end
  end
  resources :episode_trackers do
    member do
      get 'toggle_watched_season'
      get 'toggle_entire_show'
    end
  end
  resources :episodes
  resources :sessions,      only: [:new, :create, :destroy]
  resources :tv_relationships, only: [:create, :destroy]
  resources :movies
  resources :movie_trackers, only: [:create, :destroy, :update]
  resources :password_resets

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root              to: 'static_pages#home'
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/timeyWimey', to: 'static_pages#timey_wimey'
  match '/signup',  to: 'users#new'
  # match ':name', to: 'users#show', as: 'user_page'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match 'tv',       to: 'tv_shows#index'
  match 'tv/:id' => 'tv_shows#show', :as => 'tv_show_page'
  match 'activation/:confirmation_token' => 'users#activation', :as => 'confirm_user'

  # See how all your routes lay out with "rake routes"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end


  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
