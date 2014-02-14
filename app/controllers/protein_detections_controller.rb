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

    #if pdh.has_ambiguous_peptides#ESTO NO DEBERíA SER NECESARIO!
      #can this even happen? Or is it that my_file.mzid is now well built,
      #I guess public/uploaded_mzid_files/SILAC_phos_OrbitrapVelos_1... is bad  There is NO SII for which there are more than one <PeptideEvidenceRef, and I know it should, bc of PAG_100 peptide_hypotheses
      #and same thing with Orbitrap_XL_CID_SILAC_blabla_1B.mzid
      #@watch_out = "some of the peptide sequences are ambiguous, i.e. are also found in other proteins"
    #  @pdh_id = pdh.protein_detection_hypothesis_id      
    #else #all the peptide_hypotheses correspond to peptide_evidences that are mapped to ONE (the one ref in <pdh>) db_seq entry
    #  @protein_sequence = pdh.db_seq.sequence
    #  @db_seq_accession = pdh.db_seq.accession
    #end 
    
    @protein_sequence = pdh.db_seq.sequence
    @db_seq_accession = pdh.db_seq.accession
     
    @peptide_sequences = @psms.map { |psm| psm.peptide_evidence.peptide_sequence.sequence }
    
    if @protein_sequence and !@protein_sequence.blank?
      offsets = []
      @peptide_sequences.each {|pepseq| @protein_sequence.scan(pepseq){offsets << $~.offset(0)} }
      ranges = offsets.map { |o| o[0]..o[1] }
      #convierto mis offsets arrays a ranges para poder usar la funcion merge_ranges
      coverage_ranges = merge_ranges(ranges) #[5..17, 34..63]
      coverage_offsets = coverage_ranges.map {|r| [r.first, r.last] } #[[5, 17], [34, 63]]
      #pero claro, luego tengo que voler a convertir los ranges a offsets (arrays)
      @prot_seq_w_cov_tags = pdh.prot_seq_highlighted_coverage(coverage_offsets)
    end
    
   respond_to do |format|
    #  format.html { render json: @fragments  }
    #  format.json { render json: @fragments }
      format.js { render :layout => false }
    end


  end
  
  
  
  
  private
  
  def merge_ranges(ranges) #main:Object
    ranges = ranges.sort_by {|r| r.first }
    *outages = ranges.shift
    ranges.each do |r|
      lastr = outages[-1]
      if lastr.last >= r.first - 1
        outages[-1] = lastr.first..[r.last, lastr.last].max
      else
        outages.push(r)
      end
    end
    outages
  end  
  
  

end
