Rails.application.routes.draw do

  resources :bank_accounts

  resources :groups
  post "groups/join" => "groups#join", as: "join_group"

  devise_for :users, :controllers => { registrations: 'registrations'}

   root 'pages#index'

  get "users/:id/profile" => "pages#profile", as: :user_profile

  devise_for :users

  resources :bank_accounts

  resources :budgets do
    post "/create_new_income" => "budget_types#create_new_income", as: :create_new_income
    post "/create_new_expense" => "budget_types#create_new_expense", as: :create_new_expense
    post "/create_new_balance" => "budget_types#create_new_balance", as: :create_new_balance
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
