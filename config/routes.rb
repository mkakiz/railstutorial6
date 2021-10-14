Rails.application.routes.draw do

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'

  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  resources :users
      # users_path	    GET	    /users(.:format)	          users#index
      #                 POST	  /users(.:format)	          users#create
      # new_user_path	  GET	    /users/new(.:format)	      users#new
      # edit_user_path	GET	    /users/:id/edit(.:format)	  users#edit
      # user_path	      GET	    /users/:id(.:format)	      users#show
      #                 PATCH	  /users/:id(.:format)	      users#update
      #                 PUT	    /users/:id(.:format)	      users#update
      #                 DELETE	/users/:id(.:format)        users#destroy

end
