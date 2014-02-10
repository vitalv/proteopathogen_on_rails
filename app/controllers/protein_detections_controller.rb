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
  
  
  def protein_detection_hypothesis

    pdh = ProteinDetectionHypothesis.find(params[:pdh_id])
    @pep_hypotheses = pdh.peptide_hypotheses
    
    @pdh_psi_ms_cv_terms = pdh.pdh_psi_ms_cv_terms
    @pdh_user_params = pdh.pdh_user_params
    
    @psms = pdh.peptide_spectrum_assignments


    ##note: I can safely fetch psa[0] There might be more than one peptide_evidence per sii in the case "a specific sequence can be assigned to multiple proteins and or positions in a protein", but the peptide sequence is the same
    #@peptide_sequence = sii.peptide_spectrum_assignments[0].peptide_evidence.peptide_sequence.sequence
    ##for that reason, the referred protein might be different
    #@db_seq = []
    #@peptide_evidences.each do |pep_ev|
    #  @db_seq << pep_ev.db_sequence
    #end
    
    respond_to do |format|
    #  format.html { render json: @fragments  }
    #  format.json { render json: @fragments }
      format.js { render :layout => false }
    end


  end
  
  

end
