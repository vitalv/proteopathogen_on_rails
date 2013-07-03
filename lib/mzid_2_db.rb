class Mzid2db

#mzid = Mzid.new("/home/vital/proteopathogen_on_rails_3/proteopathogen_on_rails/public/uploaded_mzid_files/SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid"); nil;
#mzid = Mzid.new("/home/vital/proteopathogen_on_rails_3/proteopathogen_on_rails/public/uploaded_mzid_files/examplefile.mzid"); nil;
#mzid = Mzid.new("/home/vital/SeattleThings/PeptideAtlasExperiments_mzIdentML/CandidaRotofor-1.pep.mzid")
#mzid = Mzid.new("/home/vital/proteopathogen_on_rails_3/proteopathogen_on_rails/public/uploaded_mzid_files/CandidaRotofor-1.pep.mzid")

  def initialize(mzid_object)
    @mzid_obj = mzid_object
    @mzid_file_id = mzid_object.mzid_file_id
  end
  
  #Note on Variable naming :
  #This script deals with the objects from mzid_parser (@mzid_obj) 
  #used to create new objects (to be saved to the db, i.e. models) that refer to the same concept
  #(i.e. Create Sip object from @mzid_obj.sip object)
  #objects from mzid_parser are prefixed mzid_  ;  objects created here to be saved are prefixed my_

  #See DB Schema ../public/images/proteopathogen.png
  #Some tables are inter-search scope. Peptide for instance. No need to save a new object for every search/experiment
  #use .find_or_create methods to save these models/tables 
  #Tables in #08080 color(whatever that is called) are search-scope. Do save these things every time for every search/mzid file
  #Fragment for instance. These are always new stuff. Use .create methods. 

  def save2tables
  
    spectrum_identification_lists_ids = []
  
    @mzid_obj.spectrum_identifications.each do |mzid_si|
      my_si = saveSpectrumIdentification(mzid_si)
      saveSarSiJoinTable(mzid_si, my_si)
      mzid_sip = @mzid_obj.sip(mzid_si.sip_ref)
      my_sip = saveSip(mzid_sip, my_si)      
      saveSipPsiMsTerms(mzid_sip, my_sip)
      saveSipUserParams(mzid_sip, my_sip)
      saveSearchedModifications(mzid_sip, my_sip)
      saveSearchDatabases(mzid_si, my_si)
      spectrum_identification_lists_ids << saveSpectrumIdentificationList(mzid_si, my_si)
    end
    
    #sii_pep_evs = [] #arr of hashes: {"pepEv_id" => my_PeptideEvidence.id, "pep_ev_ref" => pep_ev_ref, "sii_ref" => mzid_item.sii_id}
    
    spectrum_identification_lists_ids.each do |sil_id|
      sil_ref = SpectrumIdentificationList.find(sil_id).sil_id
      results_arr = @mzid_obj.spectrum_identification_results(sil_ref)
      results_arr.each do |mzid_sir|
        my_sir = saveSpectrumIdentificationResult(mzid_sir, sil_id)
        saveSirPsiMsCvTerms(mzid_sir, my_sir)
        saveSirUserParams(mzid_sir, my_sir)
        pep_ev_refs = []
        mzid_sir.items_arr.each do |mzid_item|
          my_item = saveSpectrumIdentificationItem(mzid_item, my_sir)
          saveFragments(mzid_item, my_item) 
          saveSiiPsiMsCvTerms(mzid_item, my_item)
          saveSiiUserParams(mzid_item, my_item)
          mzid_item.pepEv_ref_arr.each do |pep_ev_ref|
            pep_seq_id = savePeptideSequence(pep_ev_ref)  unless pep_ev_refs.include? pep_ev_ref
            dbseq_id = saveDbSequence(pep_ev_ref, sil_id) unless pep_ev_refs.include? pep_ev_ref
            my_PeptideEvidence = savePeptideEvidence(pep_ev_ref, pep_seq_id, dbseq_id)# unless pep_ev_refs.include? pep_ev_ref
            savePeptideModifications(pep_ev_ref, my_PeptideEvidence.id, pep_seq_id)
            
            #debo tener tantos de estos como elementos en la tabla sii_pepevidences
            #sii_pep_evs << {"pepEv_id" => my_PeptideEvidence.id, "pep_ev_ref" => pep_ev_ref, "sii_ref" => mzid_item.sii_id}
           
            saveSiiPepEvidences(my_item, my_PeptideEvidence)
            pep_ev_refs << pep_ev_ref
          end
          
        end
      end
    end
    
    @mzid_obj.protein_ambigroups.each do |pag|
      pag_id = pag.pag_id
      my_pag_id = saveProteinAmbiguityGroup(pag_id)
      pag.prot_hyp_arr.each do |mzid_prot_hyp|
        my_Protein_hypothesis_id = saveProteinDetectionHypothesis(mzid_prot_hyp, my_pag_id) 
        saveProtHypPsiMsTerms(mzid_prot_hyp, my_Protein_hypothesis_id)
        saveProtHypUserParams(mzid_prot_hyp, my_Protein_hypothesis_id)
    
      end
    end
    
    
  end
  
  
  def saveSpectrumIdentification(mzid_si)
    mzid_si_id = mzid_si.si_id
    #WATCH OUT! #DON'T SAVE the same si multiple times!! How could that ever happen? Only in dev mode when I'm resubmitting the same mzid file continuously...
    #production should look like: (always create)
    #my_si = SpectrumIdentification.create(:si_id => mzid_si_id, :name => si.si_name, :activity_date => si.activity_date)
    #dev mode :  #Check if current mzid_file_id  has an already stored si with same si_id (through sar)
    this_mzid_stored_si_ids = []
    MzidFile.find(@mzid_file_id).spectra_acquisition_runs.each do |stored_sar|
      stored_sar.spectrum_identifications.each do |stored_si|
        this_mzid_stored_si_ids << stored_si.si_id
      end
    end
    my_si = nil
    if this_mzid_stored_si_ids.include? mzid_si_id
      my_si = SpectrumIdentification.find_by_si_id(mzid_si_id) 
	else
      my_si = SpectrumIdentification.create(
      :si_id => mzid_si_id, 
      :name => mzid_si.si_name, 
      :activity_date => mzid_si.activity_date)  
	end
    return my_si
  end
  
  
  def saveSarSiJoinTable(mzid_si, my_si)  
    mzid_si.input_spectra_files_arr.each do |s_f|    
      if SpectraAcquisitionRun.exists? SpectraAcquisitionRun.find_by_spectra_file(s_f) and SpectrumIdentification.exists? my_si.id
        if SpectrumIdentification.find(my_si.id).spectra_acquisition_run_ids.empty?
          my_si.spectra_acquisition_runs << SpectraAcquisitionRun.find_by_spectra_file(s_f)
        else
          new_sars = SpectraAcquisitionRun.find(:all, :conditions => ['mzid_file_id = ? AND id NOT IN (?)', @mzid_file_id, SpectrumIdentification.find(my_si.id).spectra_acquisition_run_ids])
          my_si.spectra_acquisition_runs << new_sars
        end
      end
    end
  end
  
  
  def saveSip(mzid_sip, my_si)
    sip_id = mzid_sip.sip_id
    analysis_software = mzid_sip.analysis_software
    search_type = mzid_sip.search_type
    threshold = mzid_sip.threshold
    parent_tol_plus_value, parent_tol_minus_value = mzid_sip.parent_tolerance[0][:value], mzid_sip.parent_tolerance[1][:value]
    fragment_tol_plus_value, fragment_tol_minus_value = mzid_sip.fragment_tolerance[0][:value], mzid_sip.fragment_tolerance[1][:value]
    #Check Sip model : (validates_uniqueness)
    my_sip = SpectrumIdentificationProtocol.find_or_create_by_spectrum_identification_id(
    :spectrum_identification_id => my_si.id, 
    :sip_id => sip_id, 
    :analysis_software => analysis_software, 
    :search_type => search_type, 
    :threshold => threshold, 
    :parent_tol_plus_value => parent_tol_plus_value, 
    :parent_tol_minus_value => parent_tol_minus_value, 
    :fragment_tol_plus_value => fragment_tol_plus_value, 
    :fragment_tol_minus_value => fragment_tol_minus_value) 
    return my_sip
  end
 
  
  def saveSipPsiMsTerms(mzid_sip, my_sip)
    mzid_psi_ms_terms = mzid_sip.psi_ms_terms
    unless mzid_psi_ms_terms.empty?
      mzid_psi_ms_terms.each do |psi_ms_term|
        my_psi_term = SipPsiMsCvTerm.find_or_initialize_by_spectrum_identification_protocol_id_and_psi_ms_cv_term_accession(:spectrum_identification_protocol_id => my_sip.id, :psi_ms_cv_term_accession => psi_ms_term[:accession])
        my_psi_term.value = psi_ms_term[:value] if this_psi_term.new_record? unless psi_ms_term[:value].blank?
        #SipPsiMsCvTerm has a value so, shouldn't it be always a new record? If so, then I wouln't need to find_or_initialize, just create the thing
        my_psi_term.save if my_psi_term.new_record?
      end
    end    
  end
  
  
  def saveSipUserParams(mzid_sip, my_sip)
    user_params = mzid_sip.user_params
    unless user_params.empty?
      user_params.each do |userP|
        this_userP = SipUserParam.find_or_initialize_by_spectrum_identification_protocol_id_and_name(:spectrum_identification_protocol_id => my_sip.id, :name => userP[:name])
        this_userP.value = userP[:value] if this_userP.new_record? unless userP[:value].blank?
        this_userP.save
      end
    end    
  end
  

  def saveSearchedModifications(mzid_sip, my_sip)
    searched_mod_arr = mzid_sip.searched_modification_arr
    unless searched_mod_arr.nil?
      searched_mod_arr.each do |mod|
        #Y ademas estoy insertando records que ya existian! Entonces pa que coño quiero la join table !!
        #is_fixed boolean 'true' is saved as 1 in mysql -tinyint(1)-, so watch the fuck out
        fixed = '1' if mod.fixedMod == 'true'; fixed = '0' if mod.fixedMod == 'false'
        this_mod = SearchedModification.find_or_create_by_unimod_accession_and_mass_delta_and_residue_and_is_fixed(:unimod_accession => mod.unimod_accession, :mass_delta => mod.mass_delta, :residue => mod.residue, :is_fixed => fixed)
        my_sip.searched_modifications << this_mod unless my_sip.searched_modifications.include? this_mod
      end
    end  
  end


  def saveSearchDatabases(mzid_si, my_si)
    mzid_si.search_db_arr.each do |sdb|
      this_sdb = SearchDatabase.find_or_create_by_name_and_sdb_id_and_version_and_release_date_and_number_of_sequences_and_location(:name => sdb.name, :sdb_id => sdb.sdb_id, :version => sdb.version, :release_date => sdb.releaseDate, :number_of_sequences => sdb.num_seq, :location => sdb.location)
      my_si.search_databases << this_sdb unless my_si.search_databases.include? this_sdb
    end  
  end

 
  def saveSpectrumIdentificationList(mzid_si, my_si)
    mzid_sil = @mzid_obj.sil(mzid_si.sil_ref)
    si_id = my_si.id
    sil_id = mzid_sil.sil_id
    num_seq_searched = mzid_sil.num_seq_searched
    my_sil = SpectrumIdentificationList.find_or_create_by_spectrum_identification_id(
    :sil_id => sil_id,
    :spectrum_identification_id => si_id,
    :num_seq_searched => num_seq_searched) 
    return my_sil.id
  end 
 

  def saveSpectrumIdentificationResult(mzid_sir, sil_id) 
    sir_id = mzid_sir.sir_id
    spectrum_id = mzid_sir.spectrum_id
    spectrum_name = mzid_sir.spectrum_name
    my_sir = SpectrumIdentificationResult.find_or_create_by_spectrum_identification_list_id_and_sir_id(
    :sir_id => sir_id,
    :spectrum_identification_list_id => sil_id,
    :spectrum_id => spectrum_id, 
    :spectrum_name => spectrum_name)  
    return my_sir
  end


  def saveSirPsiMsCvTerms(mzid_sir, my_sir)
    sir_psi_ms_cv_terms = mzid_sir.sir_psi_ms_cv_terms
    sir_psi_ms_cv_terms.each do |psi_ms_t|
      #this_psi_term = SirPsiMsCvTerm.find_or_initialize_by_spectrum_identification_result_id_and_psi_ms_cv_term_accession(:spectrum_identification_result_id => this_sir.id, :psi_ms_cv_term_accession => psi_ms_t[:accession])
      #this_psi_term.value = psi_ms_t[:value] if this_psi_term.new_record? unless psi_ms_t[:value].blank?
      ##WATCH OUT: SAVE ONLY IF NEW (that is, NEW in GLOBAL scope, the whole table) RECORD 
      SirPsiMsCvTerm.create(
      :spectrum_identification_result_id => my_sir.id, 
      :psi_ms_cv_term => psi_ms_t[:accession], :value => psi_ms_t[:value])
      #this_psi_term.save            
    end
  end


  def saveSirUserParams(mzid_sir, my_sir)
    sir_user_params = mzid_sir.sir_user_params
    sir_user_params.each do |userP|
      #this_userP = SirUserParam.find_or_initialize_by_spectrum_identification_result_id_and_name(:spectrum_identification_result_id => this_sir.id, :name => userP[:name])
      #this_userP.value = userP[:value] if this_userP.new_record? unless userP[:value].blank?
      SirUserParam.create(
      :spectrum_identification_result_id => my_sir.id, 
      :name => userP[:name], 
      :value => userP[:value])
      #this_userP.save
    end
  end


  def saveSpectrumIdentificationItem(mzid_item, my_sir)
    sii_id = mzid_item.sii_id
    spectrum_identification_result_id = SpectrumIdentificationResult.find_by_sir_id(my_sir.sir_id).id
    calc_m2z, exp_m2z = mzid_item.calc_m2z, mzid_item.exp_m2z
    rank, charge_state  = mzid_item.rank, mzid_item.charge_state
    pass_threshold = mzid_item.pass_threshold    
    my_item = SpectrumIdentificationItem.find_or_create_by_sii_id_and_spectrum_identification_result_id(
    :sii_id => sii_id, 
    :spectrum_identification_result_id => spectrum_identification_result_id, 
    :calc_m2z => calc_m2z, 
    :exp_m2z => exp_m2z, 
    :rank => rank, 
    :charge_state => charge_state, 
    :pass_threshold => pass_threshold )   
    return my_item
  end


  def savePeptideSequence(pep_ev_ref)
    mzid_pep_ev = @mzid_obj.pep_evidence(pep_ev_ref)
    mzid_pep_ref = mzid_pep_ev.pep_ref
    mzid_pep = @mzid_obj.pep(mzid_pep_ref)
    pep_seq = mzid_pep.sequence  
    #mzid_modif_arr = mzid_pep.modif_arr    
    my_peptide_sequence = PeptideSequence.find_or_create_by_sequence(:sequence => pep_seq)    
    return my_peptide_sequence.id
  end


  def saveDbSequence(pep_ev_ref, sil_id)
    dbseq_ref = @mzid_obj.pep_evidence(pep_ev_ref).db_seq_ref
    mzid_db_seq = @mzid_obj.db_seq(dbseq_ref)
    db_seq_accession, db_seq_description = mzid_db_seq.accession, mzid_db_seq.description
    db_seq_sequence = mzid_db_seq.sequence
    search_db_ref = mzid_db_seq.search_db_ref
    #get search_db_id(s) (through sil_id):
    si_id = SpectrumIdentificationList.find(sil_id).spectrum_identification_id
    search_db_id = SpectrumIdentification.find(si_id).search_databases.map { |sdb| sdb.id if sdb.sdb_id == search_db_ref }[0]
    #watch out searching by accession, it may change in different mzid files
    my_DbSequence = DbSequence.find_or_create_by_accession_and_search_database_id( 
    :accession => db_seq_accession, 
    :sequence => db_seq_sequence, 
    :description => db_seq_description, 
    :search_database_id => search_db_id)
    #my_DbSequence.save if my_DbSequence.new_record?
    return my_DbSequence.id
  end


  def savePeptideEvidence(pep_ev_ref, pep_seq_id, dbseq_id)  
    pep_ev = @mzid_obj.pep_evidence(pep_ev_ref)
    my_PeptideEvidence = PeptideEvidence.find_or_create_by_peptide_sequence_id_and_db_sequence_id_and_start_and_end(
    :peptide_sequence_id => pep_seq_id,
    :db_sequence_id => dbseq_id,
    :start => pep_ev.start,
    :end => pep_ev.end,
    :is_decoy => pep_ev.is_decoy,
    :pre => pep_ev.pre,
    :post => pep_ev.post)
    #my_PeptideEvidence.save if my_PeptideEvidence.new_record?    
    return my_PeptideEvidence
  end
  

  def savePeptideModifications(pep_ev_ref, pep_ev_id, pep_seq_id)
    mzid_pep_ev = @mzid_obj.pep_evidence(pep_ev_ref)
    mzid_pep_ref = mzid_pep_ev.pep_ref
    mzid_pep = @mzid_obj.pep(mzid_pep_ref)
    mzid_modif_arr = mzid_pep.modif_arr  
    my_modifications = []
    mzid_modif_arr.each do |m|
      unless m.cv_params.empty?
        unimod_acc = m.cv_params.map { |cvP| cvP[:accession] if cvP[:cvRef] == "UNIMOD" }[0] unless m.cv_params.empty?
        my_modifications << Modification.find_or_create_by_peptide_evidence_id_and_peptide_sequence_id_and_unimod_accession_and_location(
        :residue => m.residue, 
        :avg_mass_delta => m.avg_mass_delta, 
        :location => m.location, 
        :unimod_accession => unimod_acc,
        :peptide_evidence_id => pep_ev_id,
        :peptide_sequence_id => pep_seq_id)
      end
    end
    my_modifications.each { |mod|  mod.save if mod.new_record?}
  end

  
  def saveSiiPepEvidences(my_item, my_PeptideEvidence)
    unless my_item.peptide_evidences.include? my_PeptideEvidence 
      my_item.peptide_evidences << my_PeptideEvidence 
    end
  end
  

  def saveFragments(mzid_item, my_item)
    unless mzid_item.fragments_arr.empty?
      mzid_item.fragments_arr.each do |f|
        Fragment.create(
        :spectrum_identification_item_id => my_item.id, 
        :charge => f.charge, 
        :index => f.ion_index, 
        :m_mz => f.mz_value, 
        :m_intensity => f.m_intensity, 
        :m_error => f.m_err, 
        :fragment_type => f.fragment_name, 
        :psi_ms_cv_fragment_type_accession => f.fragment_psi_ms_cv_acc)
      end
    end
  end

    
  def saveSiiPsiMsCvTerms(mzid_item, my_item)
    #Again?? Wouldn't you DRY it a little (Yeah, "DRY", you know, ;-) , ;-)  )
    #sii_psi_ms_cv_terms, sii_user_params = item.sii_psi_ms_cv_terms, item.sii_user_params    
    sii_psi_ms_cv_terms = mzid_item.sii_psi_ms_cv_terms
    unless sii_psi_ms_cv_terms.empty?
      sii_psi_ms_cv_terms.each do |psi_ms_t|
        #this_psi_term = SiiPsiMsCvTerm.find_or_initialize_by_spectrum_identification_item_id_and_psi_ms_cv_term_accession(:spectrum_identification_item_id => this_item.id, :psi_ms_cv_term_accession => psi_ms_t[:accession])
        #this_psi_term.value = psi_ms_t[:value] if this_psi_term.new_record? unless psi_ms_t[:value].blank?
        #this_psi_term.save
        #This is more local-scope
        SiiPsiMsCvTerm.find_or_create_by_spectrum_identification_item_id_and_psi_ms_cv_term_accession(
        :spectrum_identification_item_id => my_item.id, 
        :psi_ms_cv_term_accession => psi_ms_t[:accession], 
        :value => psi_ms_t[:value])
      end
    end
  end 
 

  def saveSiiUserParams(mzid_item, my_item)
    sii_user_params = mzid_item.sii_user_params
    unless sii_user_params.empty?
      sii_user_params.each do |userP|
        #this_userP = SiiUserParam.find_or_initialize_by_spectrum_identification_item_id_and_name(:spectrum_identification_item_id => this_item.id, :name => userP[:name])
        #this_userP.value = userP[:value] if this_userP.new_record? unless userP[:value].blank?
        #this_userP.save
        SiiUserParam.create(
        :spectrum_identification_item_id => this_item.id, 
        :name => userP[:name], 
        :value => userP[:value])
      end
    end  
  end
    
    
  def saveProteinAmbiguityGroup(pag_id)
    pag_id = pag_id + "_Mzid_" + @mzid_file_id
    my_Pag = ProteinAmbiguityGroup.create(:pag_id => pag_id)
    return my_Pag.id
  end
  
  
  def saveProteinDetectionHypothesis(mzid_prot_hyp, my_pag_id)
    mzid_prot_hyp_id = mzid_prot_hyp.prot_hyp_id
    pass_threshold = mzid_prot_hyp.pass_thr
    name ||= mzid_prot_hyp.name
    my_Protein_hypothesis = ProteinDetectionHypothesis.find_or_create_by_protein_detection_hypothesis_id_and_protein_ambiguity_group_id(
    :protein_ambiguity_group_id => my_pag_id,
    :protein_detection_hypothesis_id => mzid_prot_hyp_id,
    :pass_threshold => pass_threshold,
    :name => name)
    return my_Protein_hypothesis.id
  end
  
  
  def saveProtHypPsiMsTerms(mzid_prot_hyp, my_prot_hyp_id)
    ##MIGRATION -> nombres de las columnas   
    prot_hyp_psi_ms_cv_terms = mzid_prot_hyp.prot_hyp_psi_ms_cv_terms
    unless prot_hyp_psi_ms_cv_terms.empty?
      prot_hyp_psi_ms_cv_terms.each do |psi_ms_t|
        ProteinDetectionHypothesisPsiMsCvTerm.find_or_create_by_protein_detection_hypothesis_id_and_psi_ms_cv_term_accession(
        :protein_detection_hypothesis_id => my_prot_hyp_id, 
        #esto dara error porque en la tabla se llama name -> hacer la migracion
        :psi_ms_cv_term_accession => psi_ms_t[:accession], 
        :value => psi_ms_t[:value])
      end
    end  
  
  end
  
  
  def saveProtHypUserParams(mzid_prot_hyp, my_prot_hyp_id)
     ##MIGRATION -> nombres de las columnas   
    prot_hyp_user_params = mzid_prot_hyp.prot_hyp_user_params
    unless sii_user_params.empty?
      sii_user_params.each do |userP|
        SiiUserParam.create(
        :spectrum_identification_item_id => this_item.id, 
        :name => userP[:name], 
        :value => userP[:value])
      end
    end  


  end
  
  
  def savePeptideHypothesis
  
  
  end
  
  
  def savePsiMsCvTerms
  
  
  end
  

end


#maybe create method to save psi_ms_cv_terms with args (model, psi_ms_terms_set) :
#  def save_psi_ms_cv_terms(model, psi_ms_terms)
#    psi_ms_terms.each do |psi_ms_term|
#      this_psi_term = model.find_or_initialize_by_spectrum_identification_protocol_id_and_psi_ms_cv_term_accession(:spectrum_identification_protocol_id => this_sip.id, :psi_ms_cv_term_accession => psi_ms_term[:accession])
#      this_psi_term.value = psi_ms_term[:value] if this_psi_term.new_record? unless psi_ms_term[:value].blank?
#      this_psi_term.save
#    end  
#  end
  
#  def save_user_params
  
#  end


  def rollback(mzid_file_id)
    if MzidFile.exists? mzid_file_id
      #puts "\n-Error saving data 2 tables. Rolling back -- \n\n"
      MzidFile.find(mzid_file_id).spectra_acquisition_runs.each do |sar|
        sar.spectrum_identifications.each do |si|
          sip_id = si.spectrum_identification_protocol.id if si.spectrum_identification_protocol
          SpectrumIdentificationProtocol.destroy(sip_id) if sip_id #SipPsiMsCvTerms and SipUserParams are :dependent => :destroy on sip.destroy
          si.spectrum_identification_results.each do |sir|
            sir.spectrum_identification_items.each do |sii|
              sii.fragments{ |fragment|Fragment.destroy(fragment.id) }
              sii.peptide_evidences.each do |pep_ev| #habtm association btwn sii and pep_ev does not support :dependent => :destroy so do it here:
                PeptideEvidence.destroy(pep_ev.id) #peptide is dependent so destroyed here as well
                
                #Peptide is not dependent-destroying! (?) Neither is Modification !
                
              end
              #sii.fragments #fragments are :dependent => :destroy on sii so don't have to destroy 
            end
            SpectrumIdentificationResult.destroy(sir.id)
          end
          SpectrumIdentificationList.destroy(SpectrumIdentificationList.find_by_spectrum_identification_id(si).id)
          SpectrumIdentification.destroy(si.id) if SpectrumIdentification.exists? (si.id)
        end
        #SpectraAcquisitionRun.destroy(sar.id)
      end
      #MzidFile.destroy(mzid_file_id)

    end

  end


