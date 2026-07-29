Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, skip: :registrations
  root 'welcome#index'
  post 'direct_uploads/presign', to: 'direct_uploads#presign'
  put 'direct_uploads/local', to: 'direct_uploads#local', as: :local_direct_uploads
  get 'uploads/*key', to: 'direct_uploads#show', as: :stored_upload, format: false

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
  #
  resources :projects do
    member do
      post :update_agency
      post :upload
      get :edit_information
      patch :update_information
      post :delete_attachment
      post :payment
      post :step_event
      get :show_money
      get :agent
      get :sales
      get :report
      get :order_import
      get :edit_owner
      patch :update_owner
      post :do_import
      get :contract_order
      post :do_contract_order
      resources :reports
      resources :orders do
        collection do
          post :place_order
          post :apply_order
        end
      end
      resources :invoices do
        collection do
          post :invoice_apply
        end
      end
    end
    collection do
      post :reapply
    end
  end

  resources :contracts do
    member do
      resources :sales do
        collection do
          get :sale_import
          post :do_import
        end
      end
    end
  end

  resources :products do
    member do
      get :contract_sales
    end
    collection do
      get :import
      post :do_import
    end
  end

  resources :audits do
    collection do
      get :orders
      get :projects
      get :bargains
      get :agents
      get :audits
      get :invoices
    end

    member do
      get :success
      get :failed_notice
      post :failed
      get :invoice_success
      get :invoice_sended
    end
  end

  resources :manage_orders do
    collection do
      post :deliver
    end
    member do
      get :edit_payment
      patch :update_payment
      get :deliver_message
      post :send_message
      get :payment_logs
      get :edit_deliver
      patch :update_deliver
      get :edit_sign
      patch :update_sign
      get :edit_fund
      patch :update_fund
      get :deliver_logs
    end
  end

  resources :manage_invoices do
    collection do
      post :upload_file
    end
  end

  resources :agents
  resources :costs
  resources :trains
  resources :competitors
  resources :notices do
    collection do
      post :check
      post :check_all
    end
  end

  resources :record_reports do
    collection do
      get 'orders'
      get 'projects'
      get 'users'
      get 'costs'
      get 'products'
      get 'invoices'
    end
  end

  resources :attachments
  resources :dynamic_reports

  # match ':controller(/:action(/:id))', :via => :get
  mount ChinaCity::Engine => '/china_city'

end
