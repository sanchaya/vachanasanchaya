require 'api_constraints'

KannadaVachana::Application.routes.draw do

  root :to => "home#index"

  get "home/index"
  match "/contact_us" => "home#contact_us"
  match "/about_us" => "home#about_us"
  match "/help" => "home#help"
  match "/admin_panel" => "home#admin_panel"


  devise_for :users
  devise_scope :user do
  get "/login" => "devise/sessions#new"
end

  resources :researches
  resources :vachanas do
    collection do
      get :vachana_concord
      get :search_vachana_number
    end
  end

  resources :vachanakaaras do
    collection do
      get :search_vachanakaara_name
    end
  end

  resources :word_lists

  resources :glossaries do
    collection do
      post :search
    end
  end

  resources :reference_books



  #for API

  namespace :api, defaults: {format: 'json'} do


#for version 1
scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do



  resources :homes
  match "/today_vachana" => "homes#today_vachana"

  resources :vachanas do
    collection do
      get :pada
    end
  end 

  resources :vachanakaaras



end




end




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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
