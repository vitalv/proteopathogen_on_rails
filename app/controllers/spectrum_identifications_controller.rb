class SpectrumIdentificationsController < ApplicationController

  def index 

    mzid_file_id = params[:mzid_file_id]
    experiment_id = MzidFile.find(mzid_file_id).experiment_id
    @exp_short_label = Experiment.find(experiment_id).short_label
    @spectrum_identifications = MzidFile.find(mzid_file_id).spectrum_identifications
    si_ids_h = {}
    @spectrum_identifications.each do |si|
      si_ids_h["data-si-id-#{si.id}"] = si.si_id
    end
    @si_ids = si_ids_h
    
    
    #decoy_psms method in si model
    
    
  end



end
