class Mzid2db

  def initialize(mzid_object)
    @mzid_obj = mzid_object
    @mzid_file_id = mzid_object.mzid_file_id
  end


  ##ATENÇAO!! Sería interesante hacer una funcion experiment_rollback que borre el ultimo experimento que he metido con todos los datos de todas las tablas (no se borrara nada en las de SIP-scope que tengan otros SIP asociados)!!
  #La idea es que una vez que se empieza a insertar datos (un experimento/busqueda) se llenen TOODAS las tablas y que no se quede a medias. Y si no se completa el proceso hacer un rollback automatico
  #ENtonces tendría que controlar que no se vuelve a insertar el mismo experimento para
  #usar  find_or_create SOLO en aquellas tablas con Global-scope  (que pueden tener records iguales en distintos SIP:experimentos/busquedas) como search_databases o peptides, etc..


  def save2tables
    
    #---- SAVE 2 SIP and associated tables -----#
    #-------------------------------------------#
    #stored_sips_for_current_mzid = []
    #MzidFile.find(@mzid_file_id).spectra_acquisition_runs.each do |sar_id|
    #  stored_sips_for_current_mzid << SpectraAcquisitionRun.find(sar_id).spectrum_identification_protocols
    #end
    
    #Aqui en lugar de recorrer los sips puedo recorrer los s_i
    #y por cada uno llamar al metodo sip y al metodo sil y guardar TOOOODO ESo, aawww yeah
    
    @mzid_obj.sips.each do |sip|
    
      sip_id = sip.sip_id
      input_spectra = sip.input_spectra      
      analysis_software = sip.analysis_software
      search_type = sip.search_type
      threshold = sip.threshold      
      search_db_arr = sip.search_db_arr
      searched_mod_arr = sip.searched_modification_arr
      psi_ms_terms = sip.psi_ms_terms
      parent_tol_plus_value, parent_tol_minus_value = sip.parent_tolerance[0][:value], sip.parent_tolerance[1][:value]
      fragment_tol_plus_value, fragment_tol_minus_value = sip.fragment_tolerance[0][:value], sip.fragment_tolerance[1][:value]
      user_params = sip.user_params
      spectra_acquisition_run_id = SpectraAcquisitionRun.find_by_spectra_file(input_spectra).id 
      #these sips refer to an input_spectra (via 1:1 <SpectrumIdentification><InputSpectra>) that EXISTS in table Spectra_acquisition_runs.spectra_file
 
       #---- SAVE 2 spectrum_identification_protocols ----
      unless SpectraAcquisitionRun.find(spectra_acquisition_run_id).spectrum_identification_protocols.any?
        this_sip = SpectrumIdentificationProtocol.create(:sip_id => sip_id, :input_spectra => input_spectra, :spectra_acquisition_run_id => spectra_acquisition_run_id, :analysis_software => analysis_software, :search_type => search_type, :threshold => threshold, :parent_tol_plus_value => parent_tol_plus_value, :parent_tol_minus_value => parent_tol_minus_value, :fragment_tol_plus_value => fragment_tol_plus_value, :fragment_tol_minus_value => fragment_tol_minus_value)
      end
      #this_sip.create . Always . Don't have to check whether record exists bc even if all this_sip columns/attributes are found in a previous record, this_sip may be a completely new experiment (for instance repeating the search with a new DB)
      #well you could check just one thing: mzid file is the same and sip_id is the same, then DO check record exists and don't insert if true
      
      #---- SAVE 2 search_databases AND sip_sdb_join_table ----   ##STILL HAVE 2 CREATE INDEX IN JOIN TABLE##
      search_db_arr.each do |sdb|
        this_sdb = SearchDatabase.find_or_create_by_name_and_version_and_release_date_and_number_of_sequences_and_location(:name => sdb.name, :version => sdb.version, :release_date => sdb.releaseDate, :number_of_sequences => sdb.num_seq, :location => sdb.location)
        #Aqui SÍ debo usar find_or_create porque es Global-scope. De hecho muchas veces irá a la parte "find"
        this_sip.search_databases << this_sdb unless this_sip.search_databases.include? this_sdb
      end
      
      #---- SAVE 2 sip_psi_ms_cv_terms ---- sip_psi_ms_cv_term es SIP-scope ??
      psi_ms_terms.each do |psi_ms_term|
        this_psi_term = SipPsiMsCvTerm.find_or_initialize_by_spectrum_identification_protocol_id_and_psi_ms_cv_term_accession(:spectrum_identification_protocol_id => this_sip.id, :psi_ms_cv_term_accession => psi_ms_term[:accession])
        this_psi_term.value = psi_ms_term[:value] if this_psi_term.new_record? unless psi_ms_term[:value].blank?
        this_psi_term.save        
      end
      
      #---- SAVE 2 sip_user_params ----
      user_params.each do |userP|
        this_userP = SipUserParam.find_or_initialize_by_spectrum_identification_protocol_id_and_name(:spectrum_identification_protocol_id => this_sip.id, :name => userP[:name])
        this_userP.value = userP[:value] if this_userP.new_record? unless userP[:value].blank?
        this_userP.save
      end
      
      #---- SAVE 2 searched_modifications ---- Global-scope
      searched_mod_arr.each do |mod|
        #Y ademas estoy insertando records que ya existian! Entonces pa que coño quiero la join table !!
        #is_fixed boolean 'true' is saved as 1 in mysql -tinyint(1)-, so watch the fuck out
        fixed = '1' if mod.fixedMod == 'true'; fixed = '0' if mod.fixedMod == 'false'
        this_mod = SearchedModification.find_or_create_by_unimod_accession_and_mass_delta_and_residue_and_is_fixed(:unimod_accession => mod.unimod_accession, :mass_delta => mod.mass_delta, :residue => mod.residue, :is_fixed => fixed)
        this_sip.searched_modifications << this_mod unless this_sip.searched_modifications.include? this_mod
      end
      
   
    end # @mzid_obj.sips.each do |sip|
    
    
    
    #---- SAVE 2 SIL and associated tables -----#
    #-------------------------------------------#    
    @mzid_obj.sils.each do |sil|
     
     
    end
    
    
  end # def save2tables




end


  def rollback(mzid_file_id)
    if MzidFile.exists? mzid_file_id
      #puts "\n-Error saving data 2 tables. Rolling back -- \n\n"
      MzidFile.find(mzid_file_id).spectra_acquisition_runs.each do |sar|
        sar.spectrum_identification_protocols.each do |sip|
          SpectrumIdentificationProtocol.destroy(sip.id)
        end
        #SpectraAcquisitionRun.destroy(sar.id)
      end
      #MzidFile.destroy(mzid_file_id)

    end
   
  end

