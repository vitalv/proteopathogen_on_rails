ProteopathogenOnRails::Application.routes.draw do

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
 
 
  namespace :admin do 
    resources :users, :experiments, :mzid_files, :spectra_acquisition_runs
    resources :mzid_files do
      post 'load2db', on: :member
      #get 'load', on: :member
    end    
  end
 
  resources :sessions

  get 'log_out', to: 'sessions#destroy', as: :log_out
  get 'log_in', to: 'sessions#new', as:  :log_in
  get 'sign_up', to: 'admin/users#new', as: :sign_up
  
  ActiveSupport::Inflector.inflections do |inflect|
    inflect.irregular 'spectrum', 'spectra'
  end


  resources :experiments do 
    resources :mzid_files
  end
  
  resources :mzid_files do
    resources :spectrum_identifications
  end 
 
  resources :spectrum_identifications do
    resources :spectrum_identification_results, path: 'results', as: 'results'
  end

  
  #resources :mzid_files, path: 'experiments', as: 'experiments' do
  #  resources :spectrum_identifications # do
      #resources :spectrum_identification_results, path: 'spectra', as: 'spectra'
    #end
  #  resources :spectrum_identification_results, path: 'spectra', as: 'spectra'
    #resources :peptide_spectrum_assignments
    #resources :peptide_evidences
    #resources :protein_detection_hypothesis
  #end
  
  
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
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  #match ':controller(/:action(/:id(.:format)))'
  


  
  
  
end
