class ProteinDetectionsController < ApplicationController

  def index

    mzid_file_id = params[:mzid_file_id]
    mzid_file = MzidFile.find(mzid_file_id)
    
    #@pd_id = params[:id]
    
    @pd = mzid_file.protein_detection
    @pdp = @pd.protein_detection_protocol
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
  
  def show
    pag = ProteinAmbiguityGroup.find(params[:id])
    @pdhs = pag.protein_detection_hypotheses
    #@sir_psi_ms_cv_terms = sir.sir_psi_ms_cv_terms
    #@sir_id_name = sir.sir_id
    #@spectrum_identification_items = sir.spectrum_identification_items    
    respond_to do |format|
      format.html 
      format.js { render  :layout => false } 
    end
  end
  
  
  def peptide_hypothesis
  
  end
  
  

end
