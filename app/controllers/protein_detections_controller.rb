class ProteinDetectionsController < ApplicationController

  def index
  
  end
  
  def show

    mzid_file_id = params[:mzid_file_id]
    experiment_id = MzidFile.find(mzid_file_id).experiment_id
    @exp_protocol = Experiment.find(experiment_id).protocol  
  
  end

end
