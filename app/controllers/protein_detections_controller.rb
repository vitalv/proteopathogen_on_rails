class ProteinDetectionsController < ApplicationController

  def index

    mzid_file_id = params[:mzid_file_id]
    mzid_file = MzidFile.find(mzid_file_id)
    
    #@pd_id = params[:id]
    
    @pd = mzid_file.protein_detection
    @pdl = @pd.protein_detection_list
    @pag_count = @pdl.protein_ambiguity_groups.count
    @pags = @pdl.protein_ambiguity_groups
    
    experiment_id = MzidFile.find(mzid_file_id).experiment_id
    @protocol = Experiment.find(experiment_id).protocol
    
    respond_to do |format|
      format.html #“if the client wants HTML in response to this action, just respond as we would have before
      format.json { 
        render json: ProteinAmbiguityGroupsDatatable.new(view_context, @pags) 
      }
    end

  end
  
  #def show

  #end

end
