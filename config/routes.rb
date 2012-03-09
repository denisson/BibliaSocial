Bibliasocial::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => 'biblia_social#index'
  
  resources :users do
    get 'seguindo', :on => :member
    get 'seguidores', :on => :member
    get 'seguir', :on => :member
    delete 'deixar', :on => :member
    resources :comments
  end
  get 'mural', :to => 'users#mural'
  
  resources :comentarios

  resources :votos
  resources :comments do
    post 'like', :on => :member
    post 'dislike', :on => :member
    get 'likes', :on => :member
    get 'dislikes', :on => :member
  end
  resources :referencias do
    post 'like', :on => :member
    post 'dislike', :on => :member
    get 'likes', :on => :member
    get 'dislikes', :on => :member
  end
  resources :links do
    post 'like', :on => :member
    post 'dislike', :on => :member
    get 'likes', :on => :member
    get 'dislikes', :on => :member
  end
  resources :videos do
    post 'like', :on => :member
    post 'dislike', :on => :member
    get 'likes', :on => :member
    get 'dislikes', :on => :member
  end
  resources :citacoes do
    post 'like', :on => :member
    post 'dislike', :on => :member
    get 'likes', :on => :member
    get 'dislikes', :on => :member
  end

  resources :versiculos do
    resources :comments
    resources :referencias
    resources :links
    resources :videos
    resources :atividades do
      get 'lista', :on => :collection
    end
  end
  
  get 'search', :to => 'biblia_social#search'
  get ':livro', :to => 'biblia_social#livro'
  get ':livro/:capitulo', :to => 'biblia_social#capitulo'
  get ':livro/:capitulo/:versiculo', :to => 'biblia_social#versiculo'
  
  #get 'auth/facebook/callback', :to => 'biblia_social#search'
  
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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end