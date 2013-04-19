Judge::Application.routes.draw do

  resources :languages
  resources :groups

  root :to => "static_pages#home"
  
  resources :submissions do
      collection do
          get :downloadInput
      end
      member do
          get :judgebot
          put :jdownload
		  put :jupload
      end
  end
  
  resources :users do
    collection do
      post :sign_in
      get :sign_out
    end
  end
    
  resources :problems do
      resources :testcases
  end
  
  match 'listexercises' => 'exercises#getvalid'
  match 'listgroups' => 'groups#list_groups'
  match 'admin' => 'static_pages#admin'
  match 'exercise/:id' => 'exercises#exercise'
  resources :exercises do
      resources :exercise_problems do
        member do
          get :download
        end
      end
      member do
        post :add_group
        get :rem_group
      end
  end
  
  resources :groups do
      member do
        post :add_user , :add_exer , :add_user_confirm
        get :rem_user , :rem_exer
      end
  end
  
  resources :exercises do
    member do
      post :add_user
    end
  end
  
  resources :users do
      member do
        post :add_group
        get :rem_group
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
