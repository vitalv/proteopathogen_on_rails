class SearchController < ApplicationController

  require 'peptide_protein_mapper.rb'
  include PeptideProteinMapper


  def index
    #@experiments = Experiment.all
  end
  
  def show
    #@exp = Experiment.friendly.find(params[:id])
    #por que va a show
  end


  def query
    @query_thing = params[:search]
    @query_thing.strip!
 
    if ProteinDetectionHypothesis.exists? protein_detection_hypothesis_id: @query_thing
      pdhs = ProteinDetectionHypothesis.where('protein_detection_hypothesis_id LIKE ?', @query_thing) #ActiveRecord::Relation, may be many! 
      @pdh_id = pdhs.take.protein_detection_hypothesis_id #take (any), all in pdh are same protein_detection_hypothesis_id
      @pdh_count = pdhs.count      
      @pdhs_in_pag = pdhs.take.protein_ambiguity_group.protein_detection_hypotheses.map {|pdh| pdh.protein_detection_hypothesis_id}
      #PARA PODER HACER EL PEPTIDE PROTEIN MAPPING NECESITO UNA SECUENCIA DE PROTEÍNA DE REFERENCIA, (DbSequence) PERO PUEDE HABER MAS DE 1 DbSequence PARA UN PDH / DbSequence.accession (Misma proteina, distintas search_databases)
      #Primero, comprobar si para mis pdhs (todos) hay mas de un db_sequence 
      db_sequence_ids, db_sequence_seqs, db_sequence_descrs = [], [], []
      pdhs.each { |pdh| pdh.peptide_hypotheses.each { |pep_hyp| db_sequence_ids << pep_hyp.peptide_spectrum_assignment.peptide_evidence.db_sequence_id } }
      distinct_referenced_db_sequences = db_sequence_ids.uniq
      #
      @uniq_reference_prot_seq = "" #Normalmente será 1, pero pueden ser más en el caso de que dos db_seq (mismo accession) hayan cambiado su seq de una version de search_database a otra
      @distinct_referenced_db_sequences_w_different_seqs = nil
      @db_seq_description = ""
      if distinct_referenced_db_sequences.count == 1
        @uniq_reference_prot_seq =  pdhs.take.peptide_hypotheses.first.peptide_spectrum_assignment.peptide_evidence.db_sequence.sequence
        @db_seq_description = pdhs.take.peptide_hypotheses.first.peptide_spectrum_assignment.peptide_evidence.db_sequence.description
      else #distinct_referenced_db_sequences.count > 1
        distinct_referenced_db_sequences.each do |db_seq_id| 
          db_sequence_seqs << DbSequence.find(db_seq_id).sequence 
          db_sequence_descrs << DbSequence.find(db_seq_id).description
        end
        if db_sequence_seqs.uniq.count == 1
          @uniq_reference_prot_seq =  pdhs.take.peptide_hypotheses.first.peptide_spectrum_assignment.peptide_evidence.db_sequence.sequence
        else
          @distinct_referenced_db_sequences_w_different_seqs = DbSequence.find(distinct_referenced_db_sequences)
        end
        if db_sequence_descrs.uniq.count == 1
          @db_seq_description = pdhs.take.peptide_hypotheses.first.peptide_spectrum_assignment.peptide_evidence.db_sequence.description
        else
          last_db_seq = DbSequence.find(distinct_referenced_db_sequences.last)
          @db_seq_description = last_db_seq.description
          @db_seq_description_addendum = "\t--description from search database #{last_db_seq.name}--"
        end
        
      end
      #
      pep_seqs = [] #all peptide sequences from all pdhs (combined, same pdh from multiple experiments)
      pdhs.each do |pdh|
        pdh.peptide_hypotheses.map do |pep_hyp| 
          pep_seqs << pep_hyp.peptide_spectrum_assignment.peptide_evidence.peptide_sequence.sequence
        end
      end
      @prot_peps_freq_hash = pep_seqs.inject(Hash.new(0)){|h,e| h[e]+=1;h}
    
      if !@uniq_reference_prot_seq.blank?
        @sequence_coverage, @prot_seq_w_cov_tags = map_peptides_2_protein(@uniq_reference_prot_seq, pep_seqs.uniq)
      end
      render 'query_prot'
 
    elsif PeptideSequence.exists? sequence: @query_thing
      peptide = PeptideSequence.where('sequence LIKE ?', @query_thing)
      @peptide_sequence = peptide.take.sequence
      @db_sequences_accessions = peptide.take.peptide_evidences.map{ |pep_ev| pep_ev.db_sequence.accession}.uniq      
      @pep_evs = PeptideSequence.where(sequence: @peptide_sequence).take.peptide_evidences
      sii_ids = []    
      @pep_evs.each { |pep_ev|  sii_ids << pep_ev.spectrum_identification_item_ids }
      @spectrum_identification_items = SpectrumIdentificationItem.find(sii_ids.flatten)
      @fragments = @spectrum_identification_items.map{ |sii| sii.fragments}
      @fragments.flatten!      
      render 'query_pept'
    else
      @not_found_string = "Sorry, your query \"#{@query_thing}\" did not retrieve any results"
      redirect_to search_path, :flash => {:error => @not_found_string}
      
    end

    
  end
  
  def pep_seq_siis

    pep_seq = params[:pep_seq]    
    @pep_evs = PeptideSequence.where(sequence: pep_seq).take.peptide_evidences    
    sii_ids = []    
    @pep_evs.each do |pep_ev|
       #verify the pep_ev has peptide hypothesis (and hence pdh) so the number of siis here is the same as in  @prot_peps_freq_hash above
       pep_ev_psms = pep_ev.peptide_spectrum_assignments
       pep_ev_peptide_hypotheses = pep_ev_psms.map { |psm| psm.peptide_hypotheses }       
       sii_ids << pep_ev.spectrum_identification_item_ids unless pep_ev_peptide_hypotheses.flatten.empty?
    end
    @spectrum_identification_items = SpectrumIdentificationItem.find(sii_ids.flatten)      
    @fragments = @spectrum_identification_items.map{ |sii| sii.fragments}
    @fragments.flatten!          
   respond_to do |format|
     format.js { render :layout => false }
   end
  
  end
  
  
  def select_ref_prot_seq
  
    db_seq = DbSequence.find(params[:db_seq_id])
    
    @selected_reference_prot_seq = db_seq.sequence
    
    #pep_seqs = db_seq.uniq_pep_sequences #see method in DbSequence model
    pdhs = ProteinDetectionHypothesis.where(protein_detection_hypothesis_id: db_seq.accession)
    pep_seqs = [] #all peptide sequences from all pdhs (combined, same pdh from multiple experiments)
    pdhs.each do |pdh|
      pdh.peptide_hypotheses.map do |pep_hyp| 
        pep_seqs << pep_hyp.peptide_spectrum_assignment.peptide_evidence.peptide_sequence.sequence
      end
    end
    
    @sequence_coverage, @prot_seq_w_cov_tags = map_peptides_2_protein(@selected_reference_prot_seq, pep_seqs.uniq)

    respond_to do |format|
      format.js { render :layout => false }
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
    #@pep_mods = @peptide_evidences[0].modifications unless @peptide_evidences.blank?
    #this (the where condition) should not be needed but :
    @pep_mods = @peptide_evidences[0].modifications.where(peptide_sequence_id: @peptide_evidences[0].peptide_sequence_id) unless @peptide_evidences.blank?
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



