Rails.application.routes.draw do

  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'

  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  resources :users
      # users_path	        GET	    /users(.:format)	          users#index
      #                     POST	  /users(.:format)	          users#create
      # new_user_path	    GET	    /users/new(.:format)	      users#new
      # edit_user_path	    GET	    /users/:id/edit(.:format)	  users#edit
      # user_path	        GET	    /users/:id(.:format)	      users#show
      #                     PATCH	  /users/:id(.:format)	      users#update
      #                     PUT	    /users/:id(.:format)	      users#update
      #                     DELETE	/users/:id(.:format)        users#destroy
        # put = whole update, patch = partial update

  resources :account_activations, only: [:edit]
      # edit_account_activation_path(token)	
      #   GET	  
      #     /account_activations/<token>/edit(.:format)	
      #       account_activations#edit
      # => user_mailer.rb works like controller
      # => edit_account_activation_url works

  resources :password_resets, only: [:new, :create, :edit, :update]      
      # password_resets_path	    POST	 /password_resets(.:format)     password_resets#create
      # new_password_reset_path	    GET	 /password_resets/new(.:format)	 password_resets#new
      # edit_password_reset_path    GET	    /password_resets/:id/edit(.:format  password_resets#edit
      # password_reset_path	        PATCH	  /password_resets/:id(.:format)	    password_resets#update
      #                             PUT	    /password_resets/:id(.:format)	    password_resets#update
  
  resources :microposts, only: [:create, :destroy]
      # microposts_path	    POST	    /microposts(.:format)	      microposts#create
      # micropost_path	    DELETE	  /microposts/:id(.:format)	  microposts#destroy
  
  resources :relationships,       only: [:create, :destroy]
      # relationships POST   /relationships(.:format)         relationships#create
      # relationship DELETE /relationships/:id(.:format)      relationships#destroy

  resources :users do
    member do
        get :following, :followers
        # following_user GET    /users/:id/following(:format)      users#following
        # followers_user GET    /users/:id/followers(.:format)     users#followers
        #                GET    /users(.:format)                   users#index
        #                POST   /users(.:format)                   users#create
        #                GET    /users/new(.:format)               users#new
        #                GET    /users/:id/edit(.:format)          users#edit
        #                GET    /users/:id(.:format)               users#show
        #                PATCH  /users/:id(.:format)               users#update
        #                PUT    /users/:id(.:format)               users#update
        #                DELETE /users/:id(.:format)               users#destroy
    end
  end
end