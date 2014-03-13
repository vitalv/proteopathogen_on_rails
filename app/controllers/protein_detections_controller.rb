class ProteinDetectionsController < ApplicationController

  def index

    @mzid_file_id = MzidFile.friendly.find(params[:mzid_file_id])
    mzid_file = MzidFile.find(@mzid_file_id)
    @mzid_file_name = mzid_file.name
    @pd = mzid_file.protein_detection
    @pdp = @pd.protein_detection_protocol
    @pdl = @pd.protein_detection_list
    @pag_count = @pdl.protein_ambiguity_groups.count
    @pags = @pdl.protein_ambiguity_groups
    
    experiment_id = MzidFile.find(@mzid_file_id).experiment_id
    @exp_short_label = Experiment.find(experiment_id).short_label
    
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
    
    #CHECK HERE WHETHER PDHS IS JUST ONE PDH.
    #IN THAT CASE I CAN DIRECTLY SHOW PDH PSI-MS CV PARAMS AND USER PARAMS, AND PROTEIN SEQ AND PSMs
    
    respond_to do |format|
      format.html 
      #if @pdhs.count > 1
        format.js { render 'show', :layout => false } 
      #else
      #  format.js { 
          ##render '_single_pdh', :layout => false
      #    redirect_to :action => 'protein_detection_hypothesis', :pdh_id => @pdhs[0].id
      #   } 
      #end
    end
  end
  
  
  def protein_detection_hypothesis

    pdh = ProteinDetectionHypothesis.find(params[:pdh_id])
    @pep_hypotheses = pdh.peptide_hypotheses
    
    @pdh_psi_ms_cv_terms = pdh.pdh_psi_ms_cv_terms
    @pdh_user_params = pdh.pdh_user_params
    
    @psms = pdh.peptide_spectrum_assignments
    
    @psm_freq = pdh.psms #see method in model
    
    if pdh.db_seq #this should not be needed, just in case .mzid file is not well constructed
      @protein_sequence = pdh.db_seq.sequence
      @db_seq_accession = pdh.db_seq.accession
      @peptide_sequences = @psms.map { |psm| psm.peptide_evidence.peptide_sequence.sequence }
    end
    
    if (@protein_sequence and !@protein_sequence.blank?) and (@peptide_sequences and !@peptide_sequences.blank?)
      offsets = []
      @peptide_sequences.each {|pepseq| @protein_sequence.scan(pepseq){offsets << $~.offset(0)} }
      unless offsets.blank? #pepseq not found in protseq, should not happen, just catch this possibility
        ranges = offsets.map { |o| o[0]..o[1] }
        #Convert offsets from arrays to ranges to use def merge_ranges
        coverage_ranges = merge_ranges(ranges) #[5..17, 34..63]
        coverage_offsets = coverage_ranges.map {|r| [r.first, r.last] } #[[5, 17], [34, 63]]
        #then convert back to arrays
        @prot_seq_w_cov_tags = pdh.prot_seq_highlighted_coverage(coverage_offsets)      
        covered_length = 0
        coverage_offsets.each { |c| covered_length += c[1]-c[0] }      
        @sequence_coverage = ((covered_length * 100).to_f / @protein_sequence.length.to_f).round 2
      end
    end
    
   respond_to do |format|
    #  format.html { render json: @fragments  }
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
