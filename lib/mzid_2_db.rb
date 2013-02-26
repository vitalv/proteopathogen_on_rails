class Mzid2db

#mzid = Mzid.new("/home/vital/proteopathogen_on_rails_3/proteopathogen_on_rails/public/uploaded_mzid_files/SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid"); nil;
#mzid = Mzid.new("/home/vital/proteopathogen_on_rails_3/proteopathogen_on_rails/public/uploaded_mzid_files/examplefile.mzid"), nil;

  def initialize(mzid_object)
    @mzid_obj = mzid_object
    @mzid_file_id = mzid_object.mzid_file_id
  end


  ##ATENÇAO!! Sería interesante hacer una funcion experiment_rollback que borre el ultimo experimento que he metido con todos los datos de todas las tablas (no se borrara nada en las de SIP-scope que tengan otros SIP asociados)!!
  #La idea es que una vez que se empieza a insertar datos (un experimento/busqueda) se llenen TOODAS las tablas y que no se quede a medias. Y si no se completa el proceso hacer un rollback automatico
  #ENtonces tendría que controlar que no se vuelve a insertar el mismo experimento para
  #usar  find_or_create SOLO en aquellas tablas con Global-scope  (que pueden tener records iguales en distintos SIP:experimentos/busquedas) como search_databases o peptides, etc..


  def save2tables
  
    spectrum_identification_lists_ids = []
  
    @mzid_obj.spectrum_identifications.each do |mzid_si|
      my_si = saveSpectrumIdentification(mzid_si)
      saveSarSiJoinTable(mzid_si, my_si)
      my_sip = saveSip(mzid_si, my_si)
      mzid_sip = @mzid_obj.sip(mzid_si.sip_ref)
      saveSipPsiMsTerms(mzid_sip, my_sip)
      saveSipUserParams(mzid_sip, my_sip)
      saveSearchedModifications(mzid_sip, my_sip)
      saveSearchDatabases(mzid_si, my_si)
      spectrum_identification_lists_ids << saveSpectrumIdentificationList(mzid_si, my_si)
    end
    
    spectrum_identification_lists_ids.each do |sil_id|
      sil_ref = SpectrumIdentificationList.find(sil_id).sil_id
      results_arr = @mzid_obj.spectrum_identification_results(sil_ref)
      results_arr.each do |mzid_sir|
        my_sir = saveSpectrumIdentificationResult(mzid_sir, sil_id)
        saveSirPsiMsCvTerms(mzid_sir, my_sir)
        saveSirUserParams(mzid_sir, my_sir)
        mzid_sir.items_arr.each do |mzid_item|
          my_item = saveSpectrumIdentificationItem(mzid_item, my_sir)
          pepEv_ref_arr = mzid_item.pepEv_ref_arr
          pepEv_ref_arr.each do |pep_ev_ref|
            #Por cada peptideEvidence tengo un Peptide y un dBSequence que tengo que guardar primero porque necesito sus ids para guardar peptideEvidence
            pep_id = savePeptide(pep_ev_ref)
            dbseq_id = saveDbSequence(pep_ev_ref, sil_id)
            my_PeptideEvidence = savePeptideEvidence(pep_ev_ref, pep_id, dbseq_id)
            saveSiiPepEvidences(my_item, my_PeptideEvidence)            
          end          
          saveFragments(mzid_item, my_item) #puedo hacer el bucle en la funcion
          
        end
      end
    end
    
  end
  
  
  def saveSpectrumIdentification(mzid_si)
    mzid_si_id = mzid_si.si_id
    #WATCH OUT! #DON'T SAVE the same si multiple times!! How could that ever happen? Only in dev mode when I'm resubmitting the same mzid file continously...
    #production should look like: (always create)
    #my_si = SpectrumIdentification.create(:si_id => mzid_si_id, :name => si.si_name, :activity_date => si.activity_date)
    #dev mode :  #Check if current mzid_file_id  has an already stored si with same si_id (through sar)
    this_mzid_stored_sis = []
    MzidFile.find(@mzid_file_id).spectra_acquisition_runs.each do |stored_sar|
      stored_sar.spectrum_identifications.each do |stored_si|
        this_mzid_stored_sis << stored_si.si_id
      end
    end
    my_si = SpectrumIdentification.find_by_si_id(mzid_si_id) if this_mzid_stored_sis.include? mzid_si_id
    my_si = SpectrumIdentification.create(:si_id => mzid_si_id, :name => mzid_si.si_name, :activity_date => mzid_si.activity_date)  unless this_mzid_stored_sis.include? mzid_si_id
    return my_si
  end
  
  
  def saveSarSiJoinTable(mzid_si, my_si)  
    mzid_si.input_spectra_files_arr.each do |s_f|
      #Aqui (ya que esto no tiene modelo) tengo que validar que existe un spectrum_identification_id y un spectra_acquisition_run_id
      if !SpectraAcquisitionRun.find_by_spectra_file(s_f).nil? and SpectrumIdentification.exists? my_si.id
        my_si.spectra_acquisition_runs << SpectraAcquisitionRun.find_by_spectra_file(s_f)
      end
    end
  end
  
  
  def saveSip(mzid_si, my_si)
    sip_id = sip.sip_id
    analysis_software = sip.analysis_software
    search_type = sip.search_type
    threshold = sip.threshold
    parent_tol_plus_value, parent_tol_minus_value = sip.parent_tolerance[0][:value], sip.parent_tolerance[1][:value]
    fragment_tol_plus_value, fragment_tol_minus_value = sip.fragment_tolerance[0][:value], sip.fragment_tolerance[1][:value]
    my_sip = SpectrumIdentificationProtocol.create(:spectrum_identification_id => si_id, :sip_id => sip_id, :analysis_software => analysis_software, :search_type => search_type, :threshold => threshold, :parent_tol_plus_value => parent_tol_plus_value, :parent_tol_minus_value => parent_tol_minus_value, :fragment_tol_plus_value => fragment_tol_plus_value, :fragment_tol_minus_value => fragment_tol_minus_value)
    return my_sip
  end
 
  
  def saveSipPsiMsTerms(mzid_sip, my_sip)
    psi_ms_terms = mzid_sip.psi_ms_terms
    unless psi_ms_terms.empty?
      psi_ms_terms.each do |psi_ms_term|
        this_psi_term = SipPsiMsCvTerm.find_or_initialize_by_spectrum_identification_protocol_id_and_psi_ms_cv_term_accession(:spectrum_identification_protocol_id => my_sip.id, :psi_ms_cv_term_accession => psi_ms_term[:accession])
        this_psi_term.value = psi_ms_term[:value] if this_psi_term.new_record? unless psi_ms_term[:value].blank?
        #SipPsiMsCvTerm has a value so, shouldn't it be always a new record? If so, then I wouln't need to find_or_initialize, just create the thing
        this_psi_term.save
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
      #Aqui SÍ debo usar find_or_create porque es Global-scope. De hecho muchas veces irá a la parte "find"
      my_si.search_databases << this_sdb unless my_si.search_databases.include? this_sdb
    end  
  end

 
  def saveSpectrumIdentificationList(mzid_si, my_si)
    sil = @mzid_obj.sil(mzid_si.sil_ref)
    si_id = my_si.id
    sil_id = sil.sil_id
    num_seq_searched = sil.num_seq_searched
    my_sil = SpectrumIdentificationList.create(:sil_id => sil_id, :spectrum_identification_id => si_id, :num_seq_searched => num_seq_searched)
    return my_sil.id
  end 
 


  def saveSpectrumIdentificationResult(mzid_sir, sil_id) 
    sir_id = mzid_sir.sir_id
    spectrum_id = mzid_sir.spectrum_id
    spectrum_name = mzid_sir.spectrum_name
    my_sir = SpectrumIdentificationResult.create(:sir_id => sir_id, :spectrum_identification_list_id => sil_id, :spectrum_id => spectrum_id, :spectrum_name => spectrum_name)  
    return my_sir
  end


  def saveSirPsiMsCvTerms(mzid_sir, my_sir)
    sir_psi_ms_cv_terms = mzid_sir.sir_psi_ms_cv_terms
    sir_psi_ms_cv_terms.each do |psi_ms_t|
      #this_psi_term = SirPsiMsCvTerm.find_or_initialize_by_spectrum_identification_result_id_and_psi_ms_cv_term_accession(:spectrum_identification_result_id => this_sir.id, :psi_ms_cv_term_accession => psi_ms_t[:accession])
      #this_psi_term.value = psi_ms_t[:value] if this_psi_term.new_record? unless psi_ms_t[:value].blank?
      ##WATCH OUT: SAVE ONLY IF NEW (that is, NEW in GLOBAL scope, the whole table) RECORD 
      SirPsiMsCvTerm.create(:spectrum_identification_result_id => my_sir.id, :psi_ms_cv_term => psi_ms_t[:accession], :value => psi_ms_t[:value])
      #this_psi_term.save            
    end
  end


  def saveSirUserParams(mzid_sir, my_sir)
    sir_user_params = mzid_sir.sir_user_params
    sir_user_params.each do |userP|
      #this_userP = SirUserParam.find_or_initialize_by_spectrum_identification_result_id_and_name(:spectrum_identification_result_id => this_sir.id, :name => userP[:name])
      #this_userP.value = userP[:value] if this_userP.new_record? unless userP[:value].blank?
      SirUserParam.create(:spectrum_identification_result_id => my_sir.id, :name => userP[:name], :value => userP[:value])
      #this_userP.save
    end
  end


  def saveSpectrumIdentificationItem(mzid_item, my_sir)
    sii_id = mzid_item.sii_id
    spectrum_identification_result_id = SpectrumIdentificationResult.find_by_sir_id(my_sir.sir_id).id
    calc_m2z, exp_m2z = mzid_item.calc_m2z, mzid_item.exp_m2z
    rank, charge_state  = mzid_item.rank, mzid_item.charge_state
    pass_threshold = mzid_item.pass_threshold    
    #pepEv_ref_arr = item.pepEv_ref_arr    
    #sii_psi_ms_cv_terms, sii_user_params = item.sii_psi_ms_cv_terms, item.sii_user_params    
    my_item = SpectrumIdentificationItem.create(:sii_id => sii_id, :spectrum_identification_result_id => spectrum_identification_result_id, :calc_m2z => calc_m2z, :exp_m2z => exp_m2z, :rank => rank, :charge_state => charge_state, :pass_threshold => pass_threshold )   
    return my_item
  end


  def savePeptide(pep_ev_ref)
    pep_ev = @mzid_obj.pep_evidence(pepEv_ref)
    pep_ref = pep_ev.pep_ref
    pep = @mzid_obj.pep(pep_ref)
    pep_seq = pep.sequence  
    this_Peptide = Peptide.find_or_create_by_sequence(:sequence => pep_seq, :peptide_id => pep_ref)
    return this_Peptide.id
  end


  def saveDbSequence(pep_ev_ref, sil_id)
    dbseq_ref = pep_ev.db_seq_ref
    db_seq = @mzid_obj.db_seq(dbseq_ref)
    db_seq_accession, db_seq_description = db_seq.accession, db_seq.description
    db_seq_sequence = db_seq.sequence
    search_db_ref = db_seq.search_db_ref
    #get search_db_id(s) (through sil_id):
    si_id = SpectrumIdentificationList.find(sil_id).spectrum_identification_id
    search_db_id = nil #validate presence in model 
    SpectrumIdentification.find(si_id).search_databases.each { |sdb| search_db_id = sdb.id if sdb.sdb_id == search_db_ref }
    this_DbSequence = DbSequence.find_or_initialize_by_accession_and_sequence(:accession => db_seq_accession, :sequence => db_seq_sequence)
    if this_DbSequence.new_record?
       this_DbSequence.description  = db_seq_description
       this_DbSequence.search_database_id = search_db_id 
       this_DbSequence.save
    end  
    return this_DbSequence.id
  end


  def savePeptideEvidence(pep_ev_ref, pep_id, dbseq_id)  
    pep_ev = @mzid_obj.pep_evidence(pep_ev_ref)
    my_PeptideEvidence = PeptideEvidence.find_or_create_by_peptide_id_and_db_sequence_id_and_start_and_end(:peptide_id => pep_id, :db_sequence_id => db_seq_id, :start => pep_ev.start, :end => pep_ev.end)
    if my_PeptideEvidence.new_record?
       my_PeptideEvidence.pre, this_PeptideEvidence.post = pep_ev.pre, pep_ev.post
       my_PeptideEvidence.is_decoy = pep_ev.is_decoy
    end
    return my_PeptideEvidence
  end
  
  
  def saveSiiPepEvidences(my_item, my_PeptideEvidence)
    unless my_item.peptide_evidences.include? my_PeptideEvidence 
      my_item.peptide_evidences << my_PeptideEvidence 
    end
  end
  

  def saveFragments(mzid_item, my_item)
    unless mzid_item.fragments_arr.empty?
      mzid_item.fragments_arr.each do |f|
        Fragment.create(:spectrum_identification_item_id => my_item.id, :charge => f.charge, :index => f.ion_index, :m_mz => f.mz_value, :m_intensity => f.m_intensity, :m_error => f.m_err, :fragment_type => f.fragment_name, :psi_ms_cv_fragment_type_accession => f.fragment_psi_ms_cv_acc)
      end
    end
  end

    ##SAVE SILs, SIRs, SIIs and STUFF##---------------------------------- #Elements <AnalysisData><SpectrumIdentificationList>
    #spectrum_identification_items_ids = []
    spectrum_identification_lists_ids.each do |sil_id|
      sil_ref = SpectrumIdentificationList.find(sil_id).sil_id
      @results_arr = @mzid_obj.spectrum_identification_results(sil_ref)
      @results_arr.each do |sir|
        #~ sir_id = sir.sir_id
        #~ spectrum_identification_list_id = SpectrumIdentificationList.find_by_sil_id(sil_ref).id
        #~ spectrum_id = sir.spectrum_id
        #~ spectrum_name = sir.spectrum_name
        #~ sir_psi_ms_cv_terms = sir.sir_psi_ms_cv_terms
        #~ sir_user_params = sir.sir_user_params
        #~ this_sir = SpectrumIdentificationResult.create(:sir_id => sir_id, :spectrum_identification_list_id => spectrum_identification_list_id, :spectrum_id => spectrum_id, :spectrum_name => spectrum_name)
        #~ unless sir_psi_ms_cv_terms.empty?
          #~ sir_psi_ms_cv_terms.each do |psi_ms_t|
            #~ #this_psi_term = SirPsiMsCvTerm.find_or_initialize_by_spectrum_identification_result_id_and_psi_ms_cv_term_accession(:spectrum_identification_result_id => this_sir.id, :psi_ms_cv_term_accession => psi_ms_t[:accession])
            #~ #this_psi_term.value = psi_ms_t[:value] if this_psi_term.new_record? unless psi_ms_t[:value].blank?
            #~ 
            #~ 
            #~ ##WATCH OUT: SAVE ONLY IF NEW (that is, NEW in GLOBAL scope, the whole table) RECORD 
            #~ 
            #~ SirPsiMsCvTerm.create(:spectrum_identification_result_id => this_sir.id, :psi_ms_cv_term => psi_ms_t[:accession], :value => psi_ms_t[:value])
            #~ #this_psi_term.save           
          #~ end
        #~ end
        #~ unless sir_user_params.empty?
          #~ sir_user_params.each do |userP|
            #~ #this_userP = SirUserParam.find_or_initialize_by_spectrum_identification_result_id_and_name(:spectrum_identification_result_id => this_sir.id, :name => userP[:name])
            #~ #this_userP.value = userP[:value] if this_userP.new_record? unless userP[:value].blank?
            #~ SirUserParam.create(:spectrum_identification_result_id => this_sir.id, :name => userP[:name], :value => userP[:value])
            #~ #this_userP.save
          #~ end
        #~ end
 #~ 
        #~ sir.items_arr.each do |item|
          #~ sii_id = item.sii_id
          #~ spectrum_identification_result_id = SpectrumIdentificationResult.find_by_sir_id(this_sir.sir_id).id
          #~ calc_m2z, exp_m2z = item.calc_m2z, item.exp_m2z
          #~ rank, charge_state  = item.rank, item.charge_state
          #~ pass_threshold = item.pass_threshold
          #~ pepEv_ref_arr = item.pepEv_ref_arr
          #~ sii_psi_ms_cv_terms, sii_user_params = item.sii_psi_ms_cv_terms, item.sii_user_params
 #~ 
          #~ #--- save SpectrumIdentificationItem ---
          #~ this_item = SpectrumIdentificationItem.create(:sii_id => sii_id, :spectrum_identification_result_id => spectrum_identification_result_id, :calc_m2z => calc_m2z, :exp_m2z => exp_m2z, :rank => rank, :charge_state => charge_state, :pass_threshold => pass_threshold ) 
          #~ #Save Peptide_Evidences, Peptides And DbSequences ---------
          #~ #OptionA: with my pep_evidence I get a dBSEq_ref and a peptide_ref
          #~ pepEv_ref_arr.each do |pepEv_ref|
            #~ #get mzid.pep_evidence:  PepEv = #<struct PepEv pepEv_id=nil, start=nil, end=nil, pre=nil, post=nil, is_decoy=nil, db_seq_ref=nil, name=nil, pep_ref=nil>
            #~ pep_ev = @mzid_obj.pep_evidence(pepEv_ref)
            #~ pep_ref = pep_ev.pep_ref
            #~ #get mzid.pep: Object Pep ( 
            #~ pep = @mzid_obj.pep(pep_ref)
            #~ pep_seq = pep.sequence
      #~ 
            #~ #--- save Peptide ---
            #~ this_Peptide = Peptide.find_or_create_by_sequence(:sequence => pep_seq, :peptide_id => pep_ref)
            #~ 
            #~ dbseq_ref = pep_ev.db_seq_ref
            #~ db_seq = @mzid_obj.db_seq(dbseq_ref)
            #~ db_seq_accession, db_seq_description = db_seq.accession, db_seq.description
            #~ db_seq_sequence = db_seq.sequence
            #~ search_db_ref = db_seq.search_db_ref
            #~ 
            #~ #get search_db_id(s) (through sil_id):
            #~ si_id = SpectrumIdentificationList.find(sil_id).spectrum_identification_id
            #~ search_db_id = nil #validate presence in model 
            #~ SpectrumIdentification.find(si_id).search_databases.each { |sdb| search_db_id = sdb.id if sdb.sdb_id == search_db_ref }
#~ 
            #~ #--- save DbSequence ---
            #~ this_DbSequence = DbSequence.find_or_initialize_by_accession_and_sequence(:accession => db_seq_accession, :sequence => db_seq_sequence)
            #~ if this_DbSequence.new_record?
              #~ this_DbSequence.description  = db_seq_description
              #~ this_DbSequence.search_database_id = search_db_id 
              #~ this_DbSequence.save
            #~ end
            #~ #--- save Peptide_Evidence
            #~ this_PeptideEvidence = PeptideEvidence.find_or_create_by_peptide_id_and_db_sequence_id_and_start_and_end(:peptide_id => this_Peptide.id, :db_sequence_id => this_DbSequence.id, :start => pep_ev.start, :end => pep_ev.end)
            #~ if this_PeptideEvidence.new_record?
              #~ this_PeptideEvidence.pre, this_PeptideEvidence.post = pep_ev.pre, pep_ev.post
              #~ this_PeptideEvidence.is_decoy = pep_ev.is_decoy
            #~ end
            #~ this_item.peptide_evidences << this_PeptideEvidence unless this_item.peptide_evidences.include? this_PeptideEvidence
            #~ 
          #~ end #pepEv_ref_arr.each do |pepEv_ref|
          
          #--- save Fragments -----------------------------------------
          unless item.fragments_arr.empty?
            item.fragments_arr.each do |f|
              Fragment.create(:spectrum_identification_item_id => this_item.id, :charge => f.charge, :index => f.ion_index, :m_mz => f.mz_value, :m_intensity => f.m_intensity, :m_error => f.m_err, :fragment_type => f.fragment_name, :psi_ms_cv_fragment_type_accession => f.fragment_psi_ms_cv_acc)
            end
          end
         
          #otra vez esto: (??) No puedes secarlo un poco?? (Sí, "secarlo", ya sabes, ;-) , ;-)  )
          unless sii_psi_ms_cv_terms.empty?
            sii_psi_ms_cv_terms.each do |psi_ms_t|
              #this_psi_term = SiiPsiMsCvTerm.find_or_initialize_by_spectrum_identification_item_id_and_psi_ms_cv_term_accession(:spectrum_identification_item_id => this_item.id, :psi_ms_cv_term_accession => psi_ms_t[:accession])
              #this_psi_term.value = psi_ms_t[:value] if this_psi_term.new_record? unless psi_ms_t[:value].blank?
              #this_psi_term.save
              #This is more local-scope
              SiiPsiMsCvTerm.create(:spectrum_identification_item_id => this_item.id, :psi_ms_cv_term_accession => psi_ms_t[:accession], :value => psi_ms_t[:value])
            end
          end
          unless sii_user_params.empty?
            sii_user_params.each do |userP|
              #this_userP = SiiUserParam.find_or_initialize_by_spectrum_identification_item_id_and_name(:spectrum_identification_item_id => this_item.id, :name => userP[:name])
              #this_userP.value = userP[:value] if this_userP.new_record? unless userP[:value].blank?
              #this_userP.save
              SiiUserParam.create(:spectrum_identification_item_id => this_item.id, :name => userP[:name], :value => userP[:value])
            end
          end
          


          
        end #items_arr.each do |item|
        
      end #results.each do |sir|
    
    end #spectrum_identification_lists_ids.each do |sil_id|
   

  end # def save2tables




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
          sip_id = si.spectrum_identification_protocol.id
          SpectrumIdentificationProtocol.destroy(sip_id)
          si.spectrum_identification_results.each do |sir|
            sir.spectrum_identification_items.each do |sii|
              sii.peptide_evidences.each do |pep_ev|
                PeptideEvidence.destroy(pep_ev.id)
              end
            end
            SpectrumIdentificationResult.destroy(sir.id)
          end
          SpectrumIdentification.destroy(si.id)
        end
        #SpectraAcquisitionRun.destroy(sar.id)
      end
      #MzidFile.destroy(mzid_file_id)

    end

  end


#~ class String
  #~ def camelcase2underscore
    #~ self.gsub(/::/, '/').
    #~ gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    #~ gsub(/([a-z\d])([A-Z])/,'\1_\2').
    #~ tr("-", "_").
    #~ downcase
  #~ end
#~ end
