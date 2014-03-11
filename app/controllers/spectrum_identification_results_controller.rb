class SpectrumIdentificationResultsController < ApplicationController

  def index
    @si = SpectrumIdentification.find(params[:spectrum_identification_id])
    @mzid_file = @si.mzid_file
    @protocol = @si.mzid_file.experiment.protocol
    @sil = @si.spectrum_identification_list
    @spectrum_identification_results = @si.spectrum_identification_list.spectrum_identification_results
    #@total_entries = @spectrum_identification_results.count
    respond_to do |format|
      format.html #“if the client wants HTML in response to this action, just respond as we would have before
      format.json { 
        render json: SpectrumIdentificationResultsDatatable.new(view_context, @spectrum_identification_results) 
      }
    end
     
  end
  
  
  def show
    sir = SpectrumIdentificationResult.find(params[:id])
    @sir_user_params = sir.sir_user_params
    @sir_psi_ms_cv_terms = sir.sir_psi_ms_cv_terms
    @sir_id_name = sir.sir_id
    @spectrum_identification_items = sir.spectrum_identification_items    
    respond_to do |format|
      format.html 
      format.js { render  :layout => false } 
    end
  end
  
  
  def identification_item
  
    sii = SpectrumIdentificationItem.find(params[:sii_id])
    @fragments = sii.fragments    
    @sii_psi_ms_cv_terms = sii.sii_psi_ms_cv_terms
    @sii_user_params = sii.sii_user_params
    @psms = sii.peptide_spectrum_assignments
    @peptide_evidences = sii.peptide_evidences 
    #note: I can safely fetch @peptide_evidences[0] There might be more than one peptide_evidence per sii in the case "a specific sequence can be assigned to multiple proteins and or positions in a protein", but the peptide sequence is the same
    @peptide_sequence = @peptide_evidences[0].peptide_sequence unless @peptide_evidences.blank?
    #for that reason, the referred protein might be different, but REMEMBER: the referred peptided (PeptideSequence in my DB), is the same, and that includes its modifications:
    @pep_mods = @peptide_evidences[0].modifications unless @peptide_evidences.blank?
    @modified_pep_seq = @peptide_evidences[0].modified_seq_html_string unless @pep_mods.blank? if !@pep_mods.nil?
    @db_seq = []
    #@peptide_evidences.each do |pep_ev|
    #  @db_seq << pep_ev.db_sequence
    #end
    respond_to do |format|
      format.html { render json: @fragments  }
      format.json { render json: @fragments }
      format.js { render :layout => false }
    end
    
  end


end
