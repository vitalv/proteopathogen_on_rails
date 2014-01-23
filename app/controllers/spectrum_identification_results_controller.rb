class SpectrumIdentificationResultsController < ApplicationController

  def index
  
    @si = SpectrumIdentification.find(params[:spectrum_identification_id])
    @protocol = @si.mzid_file.experiment.protocol
    @sil = @si.spectrum_identification_list
    @spectrum_identification_results = @si.spectrum_identification_list.spectrum_identification_results
    respond_to do |format|
      format.html #“if the client wants HTML in response to this action, just respond as we would have before
      format.json { 
        render json: SpectrumIdentificationResultsDatatable.new(view_context, @spectrum_identification_results) 
      }
    end
     
  end
  
  
  def show
    @sir_id = params[:id]
    @sir_id_name = SpectrumIdentificationResult.find(@sir_id).sir_id
    @spectrum_identification_items = SpectrumIdentificationResult.find(@sir_id).spectrum_identification_items
    respond_to do |format|
      format.html 
      format.js { render  :layout => false } 
    end
  end
  
  
  def identification_item
    sii = SpectrumIdentificationItem.find(params[:sii_id])
    @fragments = sii.fragments    
    @psi_ms_cv_terms = sii.sii_psi_ms_cv_terms
    @psms = sii.peptide_spectrum_assignments
    @peptide_evidences = sii.peptide_evidences    

    @peptide_sequence = PeptideSequence.find(sii.peptide_evidences[0].peptide_sequence_id).sequence
    @protein = DbSequence.find(sii.peptide_evidences[0].db_sequence_id)
    
    #sii_things = {fragments: @fragments, psi_ms_cv_terms: @psi_ms_cv_terms }
    respond_to do |format|
      format.html { render json: @fragments  }
      #format.html { render json: sii_things }
      #format.any { render json: @fragments }
      format.json { render json: @fragments }
      format.js { render :layout => false }
      #format.js { render json: sii_things }
    end
  end

end
