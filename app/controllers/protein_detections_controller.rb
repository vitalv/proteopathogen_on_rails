class ProteinDetectionsController < ApplicationController

  def index
  
  end
  
  def show

    mzid_file_id = params[:mzid_file_id]
    mzid_file = MzidFile.find(mzid_file_id)
    
    #@pd_id = params[:id]
    
    @pd = mzid_file.protein_detection
    @pdl = @pd.protein_detection_list
    @pag_count = @pdl.protein_ambiguity_groups.count
    
    experiment_id = MzidFile.find(mzid_file_id).experiment_id
    @exp_protocol = Experiment.find(experiment_id).protocol  
  
  end

end
