ProteopathogenOnRails::Application.routes.draw do

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
    resources :protein_detections do #remember element ProteinDetection maxOccurs: 1
      member do
        get 'protein_detection_hypothesis'
      end
    end
  end 
 
  resources :spectrum_identifications do
    resources :spectrum_identification_results, path: 'results', as: 'results' do
      member do
        get 'identification_item'
      end
    end
  end

 
  get 'about' => "about#index"
  get "about/download_structure_sql"
  get "about/download_structure_mwb"
  
  root :to => "home#index"
  
 
  
  get "*path" => 'errors#routing'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  #match ':controller(/:action(/:id(.:format)))'
  


  
  
  
end
