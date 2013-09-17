class SpectrumIdentificationsController < ApplicationController

  def index 

    mzid_file_id = params[:mzid_file_id]
    #experiment_id = MzidFile.find(mzid_file_id).experiment_id
    #@exp_protocol = Experiment.find(experiment_id).protocol    
    @spectrum_identifications = MzidFile.find(mzid_file_id).spectrum_identifications
    
  end



end
