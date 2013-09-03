class SpectrumIdentificationsController < ApplicationController

  def index 

    mzid_file_id = params[:experiment_id]
    experiment_id = MzidFile.find(mzid_file_id).experiment_id
    @exp_protocol = Experiment.find(experiment_id).protocol
    
    @spectrum_identifications = MzidFile.find(mzid_file_id).spectrum_identifications
    
    #for si in @spectrum_identifications do
    #  @input_spectra_collection = si.spectra_acquisition_runs 
    #end
    
    

  #render  :search_database
  #render  :spectrum_identification_protocol

  end



end
