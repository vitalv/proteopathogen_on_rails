class Mzid2db

#mzid = Mzid.new("/home/vital/proteopathogen_on_rails_3/proteopathogen_on_rails/public/uploaded_mzid_files/SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid"); nil;
#mzid = Mzid.new("/home/vital/proteopathogen_on_rails_3/proteopathogen_on_rails/public/uploaded_mzid_files/examplefile.mzid"); nil;
#mzid = Mzid.new("/home/vital/SeattleThings/PeptideAtlasExperiments_mzIdentML/CandidaRotofor-1.pep.mzid")
#mzid = Mzid.new("/home/vital/proteopathogen_on_rails_3/proteopathogen_on_rails/public/uploaded_mzid_files/CandidaRotofor-1.pep.mzid")

  def initialize(mzid_object)
    @mzid_obj = mzid_object
    @mzid_file_id = mzid_object.mzid_file_id
    @psi_ms_cv_terms = mzid_object.psi_ms_cv_terms
    @unimod_cv_terms = mzid_object.unimod_cv_terms
  end

  #Note to myself: revisar todos los metodos savePsiMsTerms y saveUserParams. (Estoy guardando bien? Hacer un metodo comun?)

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
  
    savePsiMsCvTerms(@psi_ms_cv_terms)
    saveUnimodCvTerms(@unimod_cv_terms)

    my_spectrum_identification_lists_ids = []
    my_Protein_detection = nil #<ProteinDetection> may not be present (minOccurs: 0)
    @mzid_obj.spectrum_identifications.each do |mzid_si|
      my_si = saveSpectrumIdentification(mzid_si)
      saveSarSiJoinTable(mzid_si, my_si)
      mzid_sip = @mzid_obj.sip(mzid_si.sip_ref)
      my_sip = saveSip(mzid_sip, my_si)
      saveSipPsiMsTerms(mzid_sip, my_sip)
      saveSipUserParams(mzid_sip, my_sip)
      saveSearchedModifications(mzid_sip, my_sip)
      saveSearchDatabases(mzid_si, my_si)
      if @mzid_obj.protein_detection
        mzid_pd = @mzid_obj.protein_detection
        my_Protein_detection = saveProteinDetection(mzid_pd) if mzid_pd.sil_ref_arr.include? mzid_si.sil_ref
      end
      my_spectrum_identification_lists_ids << saveSpectrumIdentificationList(mzid_si, my_Protein_detection, my_si) #Ojo! my_Pd puede ser null
    end

    my_protein_detection_list = nil
    if my_Protein_detection
      mzid_pd = @mzid_obj.protein_detection
      my_Pd_id = my_Protein_detection.id
      pdp_ref = mzid_pd.pdp_ref
      mzid_pdp = @mzid_obj.pdp(pdp_ref)
      my_Pdp_id = saveProteinDetectionProtocol(mzid_pdp, my_Pd_id) #get pdp from pdp_rf attr of pd. So 1 Occur as well
      savePdpPsiMsTerms(mzid_pdp, my_Pdp_id)
      savePdpUserParams(mzid_pdp, my_Pdp_id)
      pdl_ref = mzid_pd.pdl_ref
      my_protein_detection_list = saveProteinDetectionList(pdl_ref, my_Pd_id) #same as with pdp, one-one relationship
    end


    my_spectrum_identification_lists_ids.each do |sil_id|
      sil_ref = SpectrumIdentificationList.find(sil_id).sil_id
      results_arr = @mzid_obj.spectrum_identification_results(sil_ref)
      results_arr.each do |mzid_sir|
        my_sir = saveSpectrumIdentificationResult(mzid_sir, sil_id)
        saveSirPsiMsCvTerms(mzid_sir, my_sir)
        saveSirUserParams(mzid_sir, my_sir)
        mzid_sir.items_arr.each do |mzid_item|
          my_item = saveSpectrumIdentificationItem(mzid_item, my_sir)
          saveFragments(mzid_item, my_item.id)
          saveSiiPsiMsCvTerms(mzid_item, my_item.id)
          saveSiiUserParams(mzid_item, my_item.id)
          mzid_item.pepEv_ref_arr.each do |pep_ev_ref|
            pep_seq = savePeptideSequence(pep_ev_ref) #unless pep_ev_refs.include? pep_ev_ref
            dbseq = saveDbSequence(pep_ev_ref, sil_id) #unless pep_ev_refs.include? pep_ev_ref
            my_PeptideEvidence = savePeptideEvidence(pep_ev_ref, pep_seq.id, dbseq.id) # if pep_seq and dbseq
            savePeptideModifications(pep_ev_ref, my_PeptideEvidence.id, pep_seq.id) #unless pep_ev_refs.include? pep_ev_ref
            savePeptideSpectrumAssignments(my_item.id, my_PeptideEvidence.id)
          end
        end
      end
    end


    if my_protein_detection_list
      pdl_id = my_protein_detection_list.id
      pdl_ref = ProteinDetectionList.find(pdl_id).pdl_id
      pag_arr = @mzid_obj.protein_ambigroups(pdl_ref)
      pag_arr.each do |pag|
        pag_id = pag.pag_id
        my_pag_id = saveProteinAmbiguityGroup(pag_id, pdl_id)
        pag.prot_hyp_arr.each do |mzid_prot_hyp|
          my_Protein_hypothesis_id = saveProteinDetectionHypothesis(mzid_prot_hyp, my_pag_id)
          saveProtHypPsiMsTerms(mzid_prot_hyp, my_Protein_hypothesis_id)
          saveProtHypUserParams(mzid_prot_hyp, my_Protein_hypothesis_id)
          mzid_prot_hyp.pep_hyp_arr.each do |mzid_pep_hyp|
            mzid_pep_ev_ref = mzid_pep_hyp.pep_ev_ref
            mzid_pep_hyp.sii_arr.each do |mzid_sii_ref|
              savePeptideHypothesis(my_Protein_hypothesis_id, mzid_pep_ev_ref, mzid_sii_ref)
            end
          end
        end
      end
    end


  end

#-----------------------------------------------------------------------------------------------


  def savePsiMsCvTerms(psi_ms_cv_terms)
    psi_ms_cv_terms.each do |acc, name|
      PsiMsCvTerm.find_or_create_by_accession(:accession => acc, :name => name)
    end
  end


  def saveUnimodCvTerms(unimod_cv_terms)
    unimod_cv_terms.each do |acc, name|
      UnimodCvTerm.find_or_create_by_accession(:accession => acc, :name => name)
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
        my_psi_term = SipPsiMsCvTerm.find_or_create_by_spectrum_identification_protocol_id_and_psi_ms_cv_term_accession(
        :spectrum_identification_protocol_id => my_sip.id,
        :psi_ms_cv_term_accession => psi_ms_term[:accession],
        :value => psi_ms_term[:value])
      end
    end
  end


  def saveSipUserParams(mzid_sip, my_sip)
    user_params = mzid_sip.user_params
    unless user_params.empty?
      user_params.each do |userP|
        my_userP = SipUserParam.find_or_create_by_spectrum_identification_protocol_id_and_name(
        :spectrum_identification_protocol_id => my_sip.id,
        :name => userP[:name],
        :value => userP[:value])
      end
    end
  end


  def saveSearchedModifications(mzid_sip, my_sip)
    searched_mod_arr = mzid_sip.searched_modification_arr
    unless searched_mod_arr.nil?
      searched_mod_arr.each do |mod|
        fixed = '1' if mod.fixedMod == 'true'; fixed = '0' if mod.fixedMod == 'false'
        my_mod = SearchedModification.find_or_create_by_unimod_accession_and_mass_delta_and_residue_and_is_fixed(:unimod_accession => mod.unimod_accession, :mass_delta => mod.mass_delta, :residue => mod.residue, :is_fixed => fixed)
        my_sip.searched_modifications << my_mod unless my_sip.searched_modifications.include? my_mod
      end
    end
  end


  def saveSearchDatabases(mzid_si, my_si)
    mzid_si.search_db_arr.each do |sdb|
      my_sdb = SearchDatabase.find_or_create_by_name_and_sdb_id_and_version_and_release_date_and_number_of_sequences_and_location(:name => sdb.name, :sdb_id => sdb.sdb_id, :version => sdb.version, :release_date => sdb.releaseDate, :number_of_sequences => sdb.num_seq, :location => sdb.location)
      my_si.search_databases << my_sdb unless my_si.search_databases.include? my_sdb
    end
  end


  def saveSpectrumIdentificationList(mzid_si, my_Protein_detection, my_si)
    mzid_sil = @mzid_obj.sil(mzid_si.sil_ref)
    si_id = my_si.id
    pd_id = my_Protein_detection.id if my_Protein_detection
    sil_id = mzid_sil.sil_id
    num_seq_searched = mzid_sil.num_seq_searched
    my_sil = SpectrumIdentificationList.find_or_create_by_spectrum_identification_id(
    :sil_id => sil_id,
    :protein_detection_id => pd_id, #puede ser null
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
      SirPsiMsCvTerm.find_or_create_by_spectrum_identification_result_id_and_psi_ms_cv_term(
      :spectrum_identification_result_id => my_sir.id,
      :psi_ms_cv_term => psi_ms_t[:accession], :value => psi_ms_t[:value])
    end
  end


  def saveSirUserParams(mzid_sir, my_sir)
    sir_user_params = mzid_sir.sir_user_params
    sir_user_params.each do |userP|
      SirUserParam.find_or_create_by_spectrum_identification_result_id_and_name(
      :spectrum_identification_result_id => my_sir.id,
      :name => userP[:name],
      :value => userP[:value])
    end
  end


  def saveSpectrumIdentificationItem(mzid_item, my_sir)
    sii_id = mzid_item.sii_id
    spectrum_identification_result_id = SpectrumIdentificationResult.find_by_sir_id(my_sir.sir_id).id
    calc_m2z, exp_m2z = mzid_item.calc_m2z, mzid_item.exp_m2z
    rank, charge_state  = mzid_item.rank, mzid_item.charge_state
    pass_threshold = mzid_item.pass_threshold
    my_item = SpectrumIdentificationItem.find_or_create_by_sii_id_and_spectrum_identification_result_id(
    :sii_id => sii_id + "_Mzid_#{@mzid_file_id}", #Add mzid file id so when savePeptideHypothesis I can search unambiguously the spectrum_identification_id to get the peptide_spectrum_assignment_id
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
    my_peptide_sequence = PeptideSequence.find_or_create_by_sequence(:sequence => pep_seq)
    return my_peptide_sequence
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
    return my_DbSequence
  end


  def savePeptideEvidence(pep_ev_ref, pep_seq_id, dbseq_id)
    pep_ev = @mzid_obj.pep_evidence(pep_ev_ref)
    my_PeptideEvidence = PeptideEvidence.find_or_create_by_pepev_id_and_peptide_sequence_id_and_db_sequence_id_and_start_and_end(    
    :peptide_sequence_id => pep_seq_id,
    :db_sequence_id => dbseq_id,
    :start => pep_ev.start,
    :end => pep_ev.end,
    :is_decoy => pep_ev.is_decoy,
    :pre => pep_ev.pre,
    :post => pep_ev.post,
    :pepev_id => pep_ev_ref + "_Mzid_#{@mzid_file_id}") #Likewise sii, add mzid file id so when i savePeptideHypothesis I can search unambiguously the peptide_evidence_id to get the peptide_spectrum_assignment_id
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
  end


  def savePeptideSpectrumAssignments(my_item_id, my_PeptideEvidence_id)
    PeptideSpectrumAssignment.find_or_create_by_spectrum_identification_item_id_and_peptide_evidence_id(
    :spectrum_identification_item_id => my_item_id,
    :peptide_evidence_id => my_PeptideEvidence_id)
  end


  def saveFragments(mzid_item, my_item_id)
    unless mzid_item.fragments_arr.empty?
      mzid_item.fragments_arr.each do |f|
        Fragment.find_or_create_by_spectrum_identification_item_id_and_fragment_type_and_index_and_charge(
        :spectrum_identification_item_id => my_item_id,
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


  def saveSiiPsiMsCvTerms(mzid_item, my_item_id)
    #Does "DRY"  mean anything to you¿?
    sii_psi_ms_cv_terms = mzid_item.sii_psi_ms_cv_terms
    unless sii_psi_ms_cv_terms.empty?
      sii_psi_ms_cv_terms.each do |psi_ms_t|
        SiiPsiMsCvTerm.find_or_create_by_spectrum_identification_item_id_and_psi_ms_cv_term_accession(
        :spectrum_identification_item_id => my_item_id,
        :psi_ms_cv_term_accession => psi_ms_t[:accession],
        :value => psi_ms_t[:value])
      end
    end
  end


  def saveSiiUserParams(mzid_item, my_item_id)
    sii_user_params = mzid_item.sii_user_params
    unless sii_user_params.empty?
      sii_user_params.each do |userP|
        SiiUserParam.find_or_create_by_spectrum_identification_item_id(
        :spectrum_identification_item_id => my_item_id,
        :name => userP[:name],
        :value => userP[:value])
      end
    end
  end


  def saveProteinAmbiguityGroup(pag_id, pdl_id)
    my_Pag = ProteinAmbiguityGroup.find_or_create_by_protein_ambiguity_group_id_and_protein_detection_list_id(:protein_ambiguity_group_id => pag_id, :protein_detection_list_id => pdl_id)
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
    prot_hyp_psi_ms_cv_terms = mzid_prot_hyp.prot_hyp_psi_ms_cv_terms
    unless prot_hyp_psi_ms_cv_terms.empty?
      prot_hyp_psi_ms_cv_terms.each do |psi_ms_t|
        ProteinDetectionHypothesisPsiMsCvTerm.find_or_create_by_protein_detection_hypothesis_id_and_psi_ms_cv_term_accession(
        :protein_detection_hypothesis_id => my_prot_hyp_id,
        :psi_ms_cv_term_accession => psi_ms_t[:accession],
        :value => psi_ms_t[:value])
      end
    end
  end


  def saveProtHypUserParams(mzid_prot_hyp, my_prot_hyp_id)
    prot_hyp_user_params = mzid_prot_hyp.prot_hyp_user_params
    unless prot_hyp_user_params.empty?
      prot_hyp_user_params.each do |userP|
        ProteinDetectionHypothesisUserParam.create(
        :protein_detection_hypothesis_id => my_prot_hyp_id,
        :name => userP[:name],
        :value => userP[:value])
      end
    end
  end


  def savePeptideHypothesis(my_Protein_hypothesis_id, mzid_pep_ev_ref, mzid_sii_ref)
    #OJO!! Puede haber mas de un peptide evidence que se se hayan llamado con el mismo pep_ev_id (pep_ev_ref):
    #my trick to "uniquify" the pep_Ev_refs and sii_refs by adding the mzid_file_id to the string
    my_pep_ev_ref = mzid_pep_ev_ref + "_Mzid_#{@mzid_file_id}"
    my_sii_ref = mzid_sii_ref + "_Mzid_#{@mzid_file_id}"
    pepEv_id = PeptideEvidence.find_by_pepev_id(my_pep_ev_ref).id
    sii_id = SpectrumIdentificationItem.find_by_sii_id(my_sii_ref).id
    psa_id = PeptideSpectrumAssignment.where(:spectrum_identification_item_id => sii_id, :peptide_evidence_id => pepEv_id)[0].id
    PeptideHypothesis.find_or_create_by_protein_detection_hypothesis_id_and_peptide_spectrum_assignment_id(:protein_detection_hypothesis_id => my_Protein_hypothesis_id, :peptide_spectrum_assignment_id => psa_id)
  end


  def saveProteinDetection(mzid_pd)
    pd_id = mzid_pd.pd_id + "_Mzid_#{@mzid_file_id}"
    pd_name = mzid_pd.pd_name
    #watch out protein_detection_id can be "PD_1" in different mzids. Yeah, but that is why I add mzid_file_id to the pd_id    
    my_Pd = ProteinDetection.find_or_create_by_protein_detection_id(:protein_detection_id => pd_id, :name => pd_name)
    return my_Pd
  end


  def saveProteinDetectionProtocol(mzid_pdp, my_pd_id)
    pdp_id = mzid_pdp.pdp_id
    pdp_name = mzid_pdp.pdp_name
    analysis_software = mzid_pdp.analysis_software
    my_Pdp = ProteinDetectionProtocol.find_or_create_by_pdp_id_and_protein_detection_id(:protein_detection_id => my_pd_id, :pdp_id => pdp_id, :name => pdp_name, :analysis_software => analysis_software)
    return my_Pdp.id
  end


  def savePdpPsiMsTerms(mzid_pdp, my_pdp_id)
    mzid_psi_ms_terms = mzid_pdp.psi_ms_terms
    unless mzid_psi_ms_terms.empty?
      mzid_psi_ms_terms.each do |psi_ms_term|
        my_psi_term = PdpPsiMsCvTerm.find_or_create_by_protein_detection_protocol_id_and_psi_ms_cv_term_accession(
        :protein_detection_protocol_id => my_pdp_id,
        :psi_ms_cv_term_accession => psi_ms_term[:accession],
        :value => psi_ms_term[:value])
      end
    end
  end


  def savePdpUserParams(mzid_pdp, my_pdp_id)
    user_params = mzid_pdp.user_params
    unless user_params.empty?
      user_params.each do |userP|
        my_userP = PdpUserParam.find_or_create_by_protein_detection_protocol_id_and_name(
        :protein_detection_protocol_id => my_pdp_id,
        :name => userP[:name],
        :value => userP[:value])
      end
    end
  end


  def saveProteinDetectionList(pdl_ref, my_pd_id)
    pdl_id = pdl_ref
    pdl = ProteinDetectionList.find_or_create_by_protein_detection_id_and_pdl_id(:protein_detection_id => my_pd_id, :pdl_id => pdl_id)
    return pdl
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
          sil_id = si.spectrum_identification_list.id if si.spectrum_identification_list
          sip_id = si.spectrum_identification_protocol.id if si.spectrum_identification_protocol
          SpectrumIdentificationProtocol.destroy(sip_id) if sip_id #SipPsiMsCvTerms and SipUserParams are :dependent => :destroy on sip.destroy
          pd_id ||= SpectrumIdentificationList.find(sil_id).protein_detection_id if sil_id
          si.spectrum_identification_results.each do |sir|
            sir.spectrum_identification_items.each do |sii|
              sii.fragments{ |fragment|Fragment.destroy(fragment.id) }
              SpectrumIdentificationItem.destroy(sii.id)
            end
            #SpectrumIdentificationResult.destroy(sir.id)
          end
          #SpectrumIdentificationList.destroy(SpectrumIdentificationList.find_by_spectrum_identification_id(si).id)
          ProteinDetection.destroy(pd_id) if pd_id
          SpectrumIdentification.destroy(si.id) if SpectrumIdentification.exists? (si.id)
        end
        #SpectraAcquisitionRun.destroy(sar.id)
      end
      #MzidFile.destroy(mzid_file_id)
#~ 
    end

  end


